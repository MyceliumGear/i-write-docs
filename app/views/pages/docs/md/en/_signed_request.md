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
* SHA512: [binary SHA-2, 512 bits](https://en.wikipedia.org/wiki/SHA-2){:target="_blank"}
* HMAC-SHA512: [binary HMAC with SHA512](https://en.wikipedia.org/wiki/Hash-based_message_authentication_code){:target="_blank"}
* GATEWAY_SECRET: key for HMAC
* Base64StrictEncode: [Base64 encoding according to RFC 4648](https://en.wikipedia.org/wiki/Base64#RFC_4648){:target="_blank"}

For Ruby users signing is already implemented in `straight-server-kit` gem.

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
secret = 'abc'
nonce_body_hash = sha512.digest("1request body")
nonce_body_hash.bytes == [171, 212, 106, 205, 220, 123, 252, 143, 157, 8, 255, 134, 77, 189, 244, 134, 94, 31, 118, 246, 32, 103, 55, 140, 33, 54, 104, 206, 8, 36, 50, 243, 36, 16, 171, 51, 128, 234, 190, 101, 27, 119, 198, 252, 149, 146, 208, 41, 149, 177, 212, 49, 25, 143, 144, 82, 192, 57, 165, 51, 141, 50, 79, 68]
request = "POST/gateway/123/orders" + nonce_body_hash
raw_signature = OpenSSL::HMAC.digest(sha512, secret, request)
raw_signature.bytes == [212, 75, 80, 52, 4, 158, 112, 193, 124, 230, 220, 154, 131, 234, 82, 73, 209, 118, 203, 18, 223, 203, 124, 66, 117, 211, 54, 100, 96, 60, 232, 207, 14, 79, 25, 94, 18, 44, 65, 157, 179, 158, 48, 64, 105, 223, 178, 158, 231, 238, 227, 89, 9, 190, 26, 156, 125, 231, 46, 140, 102, 37, 186, 193]
signature = Base64.strict_encode64(raw_signature)
signature == "1EtQNASecMF85tyag+pSSdF2yxLfy3xCddM2ZGA86M8OTxleEixBnbOeMEBp37Ke5+7jWQm+Gpx95y6MZiW6wQ=="
~~~

Example 2:

~~~ ruby
secret = 'abc'
nonce_body_hash = sha512.hexdigest("1request body")
nonce_body_hash == "abd46acddc7bfc8f9d08ff864dbdf4865e1f76f62067378c213668ce082432f32410ab3380eabe651b77c6fc9592d02995b1d431198f9052c039a5338d324f44"
request = "POST/gateway/123/orders" + nonce_body_hash
signature = OpenSSL::HMAC.hexdigest(sha512, secret, request)
signature == "1d1349701164eb32224d15967649a2e943c0bfa0e7417c99cc387ca9b234d9f4c39f70185a4ac581e70dd03dc9ac23eb5a47de0ff341c169f0e7a4d6a2b8931b"
~~~
