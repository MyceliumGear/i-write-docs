If user cancels his purchase, it's better to cancel the Mycelium Gear order as well.

~~~ ruby
client = StraightServerKit::Client.new(gateway_id: api_gateway_id, secret: gateway_secret)
order  = client.orders.cancel(id: purchase.order_id)
~~~
