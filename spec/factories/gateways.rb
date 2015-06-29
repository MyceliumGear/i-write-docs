FactoryGirl.define do
  factory :gateway do

    confirmations_required 0
    check_signature        true

    sequence(:pubkey) do |i|
      BTC::Keychain.new(seed: "test#{i}").xpub
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
    test_mode     false

    sequence(:name) { |i| "Gateway #{i}#{Time.now.to_i}"}
    association(:user)

    factory :widget_gateway do
      site_type 'meah'
    end
  end
end
