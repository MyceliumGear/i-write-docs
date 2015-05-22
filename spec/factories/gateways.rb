FactoryGirl.define do
  factory :gateway do

    confirmations_required 0
    check_signature        true

    sequence(:pubkey) do |i|
      MoneyTree::Master.new.to_bip32(:public) 
    end
    default_currency            'BTC'
    callback_url                'http://0.0.0.0/my_store_callback'
    exchange_rate_adapter_names 'Bitpay, Coinbase, Bitstamp'
    secret                      'secret'

    description   "Yet another gateway"
    merchant_url  "mystore.com"
    country       "Somalia"
    region        "Central Somalia"
    city          "Mogadishu"

    sequence(:name) { |i| "Gateway #{i}"}
    association(:user)

  end

end
