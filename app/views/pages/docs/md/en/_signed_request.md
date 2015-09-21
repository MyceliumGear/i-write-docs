Most requests to API require a signature which protects gateway from unauthorized access.
The signature is a X-Signature **HTTP header** with a string of about 88 chars:

~~~ plain
Base64StrictEncode(
  HMAC-SHA512(
    REQUEST_METHOD + REQUEST_URI + SHA512(X-Nonce + REQUEST_BODY),
    GATEWAY_SECRET
  )
)
~~~

Where:

* REQUEST_METHOD: "GET", "POST", etc.
* REQUEST_URI: "/full/path/with?arguments&and#fragment", **without hostname**
* REQUEST_BODY: final request body string with JSON or blank string
* X-Nonce: **HTTP header** with an integer which must be incremented with each request (protects from replay attack), for example (Time.now.to_f * 1000).to_i
* SHA512: [binary SHA-2, 512 bits](https://en.wikipedia.org/wiki/SHA-2){:target="_blank"}
* HMAC-SHA512: [binary HMAC with SHA512](https://en.wikipedia.org/wiki/Hash-based_message_authentication_code){:target="_blank"}
* GATEWAY_SECRET: key for HMAC
* Base64StrictEncode: [Base64 encoding according to RFC 4648](https://en.wikipedia.org/wiki/Base64#RFC_4648){:target="_blank"}

For Ruby users signing is already implemented in [straight-server-kit](https://rubygems.org/gems/straight-server-kit) gem.

There is a tiny chance, that request will fail with "X-Nonce is invalid" error because of simultaneous signed request with a greater nonce. This may be recovered by repeating request with the updated nonce and signature.

Some languages like JavaScript have poor support for binary string, so hexdigest signature is also valid.

~~~ plain
HMAC-SHA512(
  REQUEST_METHOD + REQUEST_URI + SHA512(X-Nonce + REQUEST_BODY),
  GATEWAY_SECRET
)
~~~

Where:

* SHA512: [hex-encoded](https://en.wikipedia.org/wiki/Hexadecimal){:target="_blank"} SHA-2, 512 bits
* HMAC-SHA512: [hex-encoded](https://en.wikipedia.org/wiki/Hexadecimal){:target="_blank"} HMAC with SHA512


Example 1:

~~~ ruby
require 'base64'
require 'openssl'
sha512 = OpenSSL::Digest::SHA512.new

secret = '5ioHLiVwxqkS6Hfdev8pNQfhA9xy7dK957RBVYycMhfet23BTuGUPbYxA9TP6x9P'
nonce = 1442214027577 # (Time.now.to_f * 1000).to_i
body = ''
nonce_body_hash = sha512.digest(nonce.to_s + body.to_s)
nonce_body_hash.bytes == [123, 43, 252, 100, 228, 170, 180, 74, 102, 78, 146, 144, 197, 246, 136, 25, 81, 207, 216, 218, 222, 86, 40, 184, 184, 181, 177, 204, 2, 160, 123, 2, 221, 81, 181, 97, 213, 106, 107, 213, 182, 25, 151, 12, 153, 7, 180, 215, 67, 66, 14, 202, 216, 115, 106, 18, 84, 221, 241, 253, 77, 104, 193, 203]
request = "POST/gateways/6930af63a087cad5cd920e12e4729fe4f777681cb5b92cbd9a021376c0f91930/orders?amount=1&keychain_id=1" + nonce_body_hash
raw_signature = OpenSSL::HMAC.digest(sha512, secret, request)
raw_signature.bytes == [166, 197, 147, 167, 160, 132, 102, 44, 80, 195, 253, 1, 47, 61, 213, 12, 204, 129, 177, 11, 243, 86, 156, 85, 166, 69, 180, 246, 80, 208, 21, 100, 104, 32, 236, 166, 179, 212, 8, 203, 113, 84, 43, 17, 176, 184, 147, 25, 117, 212, 236, 177, 165, 253, 146, 131, 240, 101, 232, 186, 46, 61, 35, 20]
signature = Base64.strict_encode64(raw_signature)
signature == "psWTp6CEZixQw/0BLz3VDMyBsQvzVpxVpkW09lDQFWRoIOyms9QIy3FUKxGwuJMZddTssaX9koPwZei6Lj0jFA=="

# $ curl -H "X-Nonce: 1442214027577" -H "X-Signature: psWTp6CEZixQw/0BLz3VDMyBsQvzVpxVpkW09lDQFWRoIOyms9QIy3FUKxGwuJMZddTssaX9koPwZei6Lj0jFA==" -X POST 'https://gateway.gear.mycelium.com/gateways/6930af63a087cad5cd920e12e4729fe4f777681cb5b92cbd9a021376c0f91930/orders?amount=1&keychain_id=1'
# {"status":0,"amount":438481,"address":"mwtoSKLYQiAXtm2h7JV4aZtrixNjzESbYB","tid":null,"id":2562,"payment_id":"27066a1344323db82bb8f20e0fc209e58178a79edb61ca522c22946728f16c66","amount_in_btc":"0.00438481","amount_paid_in_btc":"0.0","keychain_id":1,"last_keychain_id":1}
~~~

Example 2:

~~~ ruby
require 'openssl'
sha512 = OpenSSL::Digest::SHA512.new

secret = '5ioHLiVwxqkS6Hfdev8pNQfhA9xy7dK957RBVYycMhfet23BTuGUPbYxA9TP6x9P'
nonce = 1442214785601 # (Time.now.to_f * 1000).to_i
body = ''
nonce_body_hash = sha512.hexdigest(nonce.to_s + body.to_s)
nonce_body_hash == "ae1a1076b17a25db88a98c9cc7a563d76ea495326731ae4280a7ba23d49d0f72b3279db3526e6aa478d1d3534d2e493fd85f707270bb616d789aa49041498f8e"
request = "POST/gateways/6930af63a087cad5cd920e12e4729fe4f777681cb5b92cbd9a021376c0f91930/orders?amount=1&keychain_id=1" + nonce_body_hash
signature = OpenSSL::HMAC.hexdigest(sha512, secret, request)
signature == "c08fdd361cf9a39e9fb0f908d4ff1c9799c46eb0721b4ed69de3353b087ae4e6fa321dbe047d004e7e8444a44b455eb511c56a60441c6ebe3a610bd855bbb865"

# $ curl -H "X-Nonce: 1442214785601" -H "X-Signature: c08fdd361cf9a39e9fb0f908d4ff1c9799c46eb0721b4ed69de3353b087ae4e6fa321dbe047d004e7e8444a44b455eb511c56a60441c6ebe3a610bd855bbb865" -X POST 'https://gateway.gear.mycelium.com/gateways/6930af63a087cad5cd920e12e4729fe4f777681cb5b92cbd9a021376c0f91930/orders?amount=1&keychain_id=1'
# {"status":0,"amount":438481,"address":"mwtoSKLYQiAXtm2h7JV4aZtrixNjzESbYB","tid":null,"id":2563,"payment_id":"f352e5542646f98e7035f4d6636efefece08a96db5427ede3cc82e3076e5d4b7","amount_in_btc":"0.00438481","amount_paid_in_btc":"0.0","keychain_id":1,"last_keychain_id":1}
~~~

Example 3:

~~~ ruby
require 'openssl'
sha512 = OpenSSL::Digest::SHA512.new

secret = '5ioHLiVwxqkS6Hfdev8pNQfhA9xy7dK957RBVYycMhfet23BTuGUPbYxA9TP6x9P'
nonce = 1442215362723 # (Time.now.to_f * 1000).to_i
body = '{"amount":1,"keychain_id":1}'
nonce_body_hash = sha512.hexdigest(nonce.to_s + body.to_s)
nonce_body_hash == "5e587ea40fc9f5a04746aac4f2c90c78fe49cd24d2d208d12732101e0a5c12f00583655925228c25fe68a1197b5b3e478b75a4351bb38d95c18353f3d6bfe569"
request = "POST/gateways/6930af63a087cad5cd920e12e4729fe4f777681cb5b92cbd9a021376c0f91930/orders" + nonce_body_hash
signature = OpenSSL::HMAC.hexdigest(sha512, secret, request)
signature == "4d1e6b02f30aa6ca0c0fafeedea3e785ad9929a7bb8645c2621413abfebf68323791ae6bb76e8374b48db09c4bfdba4c083c5916de2f0f582ac68a32cefe63f1"

# $ curl -H "Content-Type: application/json" -H "X-Nonce: 1442215362723" -H "X-Signature: 4d1e6b02f30aa6ca0c0fafeedea3e785ad9929a7bb8645c2621413abfebf68323791ae6bb76e8374b48db09c4bfdba4c083c5916de2f0f582ac68a32cefe63f1" -X POST -d '{"amount":1,"keychain_id":1}' 'https://gateway.gear.mycelium.com/gateways/6930af63a087cad5cd920e12e4729fe4f777681cb5b92cbd9a021376c0f91930/orders'
# {"status":0,"amount":438481,"address":"mwtoSKLYQiAXtm2h7JV4aZtrixNjzESbYB","tid":null,"id":2564,"payment_id":"35bf5bd6aafcadf336be042582203e94211844c973ef67e83f681a9e2b907dd0","amount_in_btc":"0.00438481","amount_paid_in_btc":"0.0","keychain_id":1,"last_keychain_id":1}
~~~
