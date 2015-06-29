Most requests to API require signature which protects gateway from unauthorized access.
A signature is a X-Signature header with a string of about 88 chars:

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
* REQUEST_URI: "/full/path/with?arguments&and#fragment"
* REQUEST_BODY: final string with JSON or blank string
* X-Nonce: header with an integer which must be incremented with each request (protects from replay attack), for example (Time.now.to_f * 1000).to_i
* SHA512: [binary SHA-2, 512 bits](https://en.wikipedia.org/wiki/SHA-2)
* HMAC-SHA512: [binary HMAC with SHA512](https://en.wikipedia.org/wiki/Hash-based_message_authentication_code)
* GATEWAY_SECRET: key for HMAC
* Base64StrictEncode: [Base64 encoding according to RFC 4648](https://en.wikipedia.org/wiki/Base64#RFC_4648)

For Ruby users signing is already implemented in `straight-server-kit` gem.

There is a tiny chance, that request will fail with "X-Nonce is invalid" error because of simultaneous signed request with a greater nonce. This may be recovered by repeating request with the updated nonce and signature.