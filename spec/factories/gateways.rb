FactoryGirl.define do
  factory :gateway do

    confirmations_required 0
    check_signature        true

    pubkey                      'xpub6AHA9hZDN11k2ijHMeS5QqHx2KP9aMBRhTDqANMnwVtdyw2TDYRmF8PjpvwUFcL1Et8Hj59S3gTSMcUQ5gAqTz3Wd8EsMTmF3DChhqPQBnU'
    default_currency            'BTC'
    callback_url                'http://0.0.0.0/my_store_callback'
    exchange_rate_adapter_names 'Bitpay, Coinbase, Bitstamp'
    secret                      'secret'

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
