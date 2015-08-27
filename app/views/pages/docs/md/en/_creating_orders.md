Creating an order is the first step towards accepting a payment. Generally, you want to create an order AFTER your customer clicks "Complete purchase" or a similar button in your online store. After you create an order using our RESTFUL API, you can redirect the user to the Mycelium Gear payment page associated with this order.

## The request and the signature

To create an order, you should issue a [signed](/docs/signed_request) POST request to `https://gateway.gear.mycelium.com/gateways/:gateway_id/orders` with at least one param — `amount` — it determines the amount to be paid for this order. The amount should be in the currency you have previously set for the gateway. If the gateway currency is BTC, then the amount is normally in satoshis. So, the request may look like this:

~~~ plain
POST /gateways/:api_gateway_id/orders?amount=1
~~~

You can get the `api_gateway_id` value from your gateway's info in the admin panel.

Keychain id is used to generate an address for the next order. It can be any integer > 0, but it's better if it is a consecutive integer, so keep track of your order ids in your application. With the keychain id, the request will look like this:

~~~ plain
POST /gateways/:api_gateway_id/orders?amount=1&keychain_id=1
~~~

## Sending additional data

You may want to send some additional data with the transaction that will later be returned to you, unchanged, in the callback. This is useful if you wish to identify which record in your DB is associated with which order by using something other than `order_id`.

For example, suppose you have a `Purchase` model in your Rails app. You then might want to create a purchase and send its id in the `callback_data` param:

~~~ plain
POST /gateways/:api_gateway_id/orders?amount=1&keychain_id=1&callback_data=purchase_id_123
~~~

Later on, when the callback request is issued, this `callback_data` param will be returned back with it and you'll be able to find that purchase in your DB.

## The response

In response to the request above, you will receive the following json from Mycelium Gear:

~~~ plain
{"status": 0, "amount":1, "address":"12REjGNsZfdWj5kWTuMZ2p6WPeyWFWwUT8", "tid":null, "id":1298, payment_id:"5fb72e26b23cef0900779487698893b6f566e9b8386dfb57bfabe30448b7b163", "amount_in_btc":"0.00000001", "amount_paid_in_btc":"0.00000001", "keychain_id":1, "last_keychain_id":1}
~~~

With this information, you can either manually display the payment address to the customer on your website (so he doesn't even have to leave your site), or you can redirect him to the Mycelium Gear payment page using the `payment_id`. The payment page url for redirection will then be:

~~~ plain
https://gateway.gear.mycelium.com/pay/5fb72e26b23cef0900779487698893b6f566e9b8386dfb57bfabe30448b7b163
~~~

## Address reuse and `keychain_id`

`keychain_id` is used to derive the next address from your BIP32 pubkey. If you try to create orders with the same `keychain_id` they will also have the same address, which is, as you can imagine, not a very good idea. However it is allowed and there's a good reason for that.

Wallets that support BIP32 pubkeys will only do a forward address lookup for a limited number of addreses. For example, if you have 20 expired, unpaid orders and someone sends you money to the address of the 21-st order, your wallet may not see that. Thus, it is important to ensure that there are no more than 20 expired orders in a row.

If you have 20 orders in a row and try to create another one, Gear will see that and will automatically reuse the `keychain_id` (and consequently, the address too) of the 20-th order. It will also set the 21-st order's `reused` field to the value of `1`. You will see it marked as reused in the admin panel too.

CAUTION: It is very important to make sure that you don't accidentally provide `keychain_id` that is too far away from the last used one. For example, if the gateway's `last_keychain_id` is `10`, do not use `35` for the next order, use `11`. `last_keychain_id` is always returned with other info when you create or check order status. Make sure yu always track `last_keychain_id` in your application - it is normally returned to you in the json with the other order info when you create or check orders.

## Code example

Suppose you have a Rails controller with an action called `complete_purchase` which handles customer requests when they hit the "Complete purchase" button on your site. This is what code for it may look like:

~~~ ruby
require 'straight-server-kit'

def complete_purchase

  # Save purchase in own DB
  purchase  = Purchase.create(…)

  # Perform signed request to Mycelium Gear API
  client    = StraightServerKit::Client.new(gateway_id: api_gateway_id, secret: gateway_secret)
  new_order = StraightServerKit::Order.new(amount: purchase.amount, callback_data: purchase.id)
  order     = client.orders.create(new_order)

  # Save order reference
  purchase.update(order_id: order.id)

  # Redirect customer to the payment page
  redirect_to client.pay_url(order)
end
~~~
