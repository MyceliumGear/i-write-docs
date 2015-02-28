require 'rails_helper'

RSpec.describe Gateway, type: :model do

  describe "validations" do

    before(:each) do
      @gateway = build(:gateway)
    end

    it "validates exchange_rate_adapter_names are actual available classes" do
      @gateway.exchange_rate_adapter_names = "Bitpay, Coinbase, Btce"
      expect(@gateway.valid?).to be_truthy
      @gateway.exchange_rate_adapter_names = "Bitpay, Coinbase, Nonexistent"
      expect(@gateway.valid?).to be_falsy
      @gateway.exchange_rate_adapter_names = ""
      expect(@gateway.valid?).to be_truthy
    end

    it "sets #check_signature to false for Widget gateways" do
      @gateway.widget = true
      @gateway.save
      expect(@gateway.check_signature).to be_falsy 
      @gateway.widget = false
      @gateway.save
      expect(@gateway.check_signature).to be_truthy
    end
    
    describe "generating secret" do

      it "generates a secret for a new record" do
        @gateway.save
        expect(@gateway.secret).not_to be_nil
      end

      it "doesn't generate a secret on update" do
        @gateway.save
        old_secret = @gateway.secret
        @gateway.update(name: "New gateway name", regenerate_secret: false)
        expect(@gateway.secret).to eq(old_secret)
      end

      it "regenerates a secret on update if requested" do
        @gateway.save
        old_secret = @gateway.secret
        @gateway.update(name: "New gateway name", regenerate_secret: "1")
        expect(@gateway.secret).not_to eq(old_secret)
      end

    end

    describe "straight-server integration" do

      before(:each) do
        @gateway.save
        @straight_gateway = StraightServer::Gateway[@gateway.straight_gateway_id]
      end

      it "creates a gateway with the exact same settings as the fields of the AR model" do
        expect(@straight_gateway).not_to be_nil
        expect(@straight_gateway.confirmations_required).to eq(@gateway.confirmations_required)
        expect(@straight_gateway.pubkey).to                 eq(@gateway.pubkey)
        expect(@straight_gateway.name).to                   eq(@gateway.name)
        expect(@straight_gateway.check_signature).to        eq(@gateway.check_signature)
        expect(@straight_gateway.exchange_rate_adapter_names).to eq(@gateway.exchange_rate_adapter_names)
        expect(@straight_gateway.active).to eq(@gateway.active)
      end

      it "updates a gateway with the changed fields from the model" do
        @gateway.update_attributes(name: "New Gateway Name", active: false)
        expect(@straight_gateway.reload.name).to eq("New Gateway Name")
        expect(@straight_gateway.active).to   be_falsy
      end

      it "shows gateway stats about orders" do
        expect(@gateway.order_counters).to eq({new: 0, unconfirmed: 0, paid: 0, underpaid: 0, overpaid: 0, expired: 0 })
      end


      describe "finding orders" do

        before(:each) do
          @orders = create_list(:order, 3, gateway_id: @gateway.straight_gateway_id)
        end

        it "finds all orders for the gateway" do
          found_orders = @gateway.orders 
          expect(found_orders.size).to eq(3)
          expect(found_orders).to      include(*@orders)
        end

        it "allows to paginate orders" do
          found_orders = @gateway.orders(paginate: { per_page: 2, page: 1})
          expect(found_orders.size).to eq(2)
          expect(found_orders).to      include(@orders[0], @orders[1])
        end

      end

    end

  end

end
