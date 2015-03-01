namespace :db do
  namespace :populate do

    #if Kernel.const_defined?("Faker")

      desc "removes gateways and orders"
      task clear: [:environment] do
        StraightServer.db_connection[:orders].delete
        StraightServer.db_connection[:gateways].delete
        Gateway.delete_all
      end

      desc "creates gateways"
      task gateways: [:environment] do
        print "Creating gateways"
        gateway_data = { "Overstock Inc." => "xpub6AHA9hZDN11k2ijHMeS5QqHx2KP9aMBRhTDqANMnwVtdyw2TDYRmF8PjpvwUFcL1Et8Hj59S3gTSMcUQ5gAqTz3Wd8EsMTmF3DChhqPQBnU",
          "Amazon" => "xpub6BN9pcMYNq8aNptJQrorjawWPCJ24cn7NdWoeftc1CFGFdU6NqNwB1Vqe5GMLREcydmqFtkRqrigMKD6zB45SxyVzqhQEqFee1MfquzyQmP",
          "Newegg" => "xpub6AA8e3hZmUCfvvomUJfGmSdtMtostUFcTF2cDbsuypG3xAPdfwukabrNoCSC62dLt2bymFciAU96VtPP1epXceg39KQ3RJHixw9Csp2duYp",
          "SomeRetailer" => "xpub69pyXokSPMGStEwSgAzYgSV91btBG9Fz65T5FAHu9rNdxBsE7qBBCfHPntqLA7SjuUSmmpxBouL26uqJPEVpbC5p4ZVEm8ymxRRHzk8LY1V",
          "Apple" => "xpub6BKgTXMVWKVNcGiUftkvWswC9LR17oqb8oMH3Eej5LigUmsa4Hz8y4BaSazoTwwb9qWs6KcGCES4bfH5r3ZbFjPZfbzr1bPGUqUWJ2zB26Q"
        }

        gateway_data.each do |name, pubkey|
          print "."
          Gateway.create!(
            name: name,
            pubkey: pubkey,
            user: @user ||= User.last
          )
        end
        print "done\n"
      end

      desc "creates orders in the StraightServer db for each gateway found"
      task orders: [:environment] do

        StraightServer.logger       = Logger.new(STDOUT)
        StraightServer.logger.level = Logger::FATAL 

        print "Creating orders"

        statuses = Straight::Order::STATUSES.values
        Gateway.find_each do |g|

          g.straight_gateway.check_signature = false

          15.times do
            print "."
            o = g.straight_gateway.create_order(
              amount: (1..100).to_a.sample,
              btc_denomination: 'mbtc',
              gateway_id: g.straight_gateway_id,
            )
            o[:status] = statuses.sample
            o.save
          end


        end
        print "done!\n"
      end

    #end

  end
end
