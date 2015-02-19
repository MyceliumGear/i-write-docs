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

  end

end
