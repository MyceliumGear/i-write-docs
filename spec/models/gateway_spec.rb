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

    describe "straight-server integration" do

      before(:each) do
        @gateway = create(:gateway)
      end

      it "creates a gateway with the exact same settings as the fields of the AR model" do
        straight_gateway = StraightServer::Gateway[@gateway.straight_gateway_id]
        expect(straight_gateway).not_to be_nil
        expect(straight_gateway.confirmations_required).to eq(@gateway.confirmations_required)
        expect(straight_gateway.pubkey).to                 eq(@gateway.pubkey)
        expect(straight_gateway.name).to                   eq(@gateway.name)
        expect(straight_gateway.check_signature).to        eq(@gateway.check_signature)
        expect(straight_gateway.exchange_rate_adapter_names).to eq(@gateway.exchange_rate_adapter_names)
      end

      it "updates a gateway with the changed fields from the model"
      it "turns a gateway on/off"
      it "shows gateway stats about orders"
      it "finds all orders for the gateway"

    end

  end

end
