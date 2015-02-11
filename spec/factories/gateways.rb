FactoryGirl.define do
  factory :gateway do

    confirmations_required 0
    check_signature        true

    pubkey                      'xpub-xxx'
    default_currency            'BTC'
    callback_url                'http://0.0.0.0/my_store_callback'
    exchange_rate_adapter_names 'Bitpay, Coinbase, Bitstamp'

    description   "Yet another gateway"
    merchant_url  "mystore.com"
    merchant_name "MyStore"
    country       "Somalia"
    region        "Central Somalia"
    city          "Mogadishu"

    db_config nil # we use the default app wide config here

    sequence(:name) { |i| "Gateway #{i}"}
    association(:user)

  end

end
