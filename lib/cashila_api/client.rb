require 'base64'
require 'openssl'
require 'multi_json'
require 'faraday'

module CashilaAPI
  class Client

    DEFAULT_URL = 'https://cashila-staging.com'

    InvalidCredentials = Class.new(ArgumentError)

    class ApiError < StandardError

      attr_reader :raw, :code

      def initialize(error)
        @raw  = error
        @code = error['code']
        super error['user_message'] || error['message']
      end
    end

    attr_accessor :client_id, :token, :secret, :url

    def initialize(client_id:, token: nil, secret: nil, url: DEFAULT_URL)
      @url       = url
      @token     = token
      @secret    = secret
      @client_id = client_id
    end

    def request_signup
      response = connection.post('/api/v1/request-signup')
      result   = parse_response(response)
      @token   = result['token']
      @secret  = result['secret']
      result
    end

    # @param [AddressProviders::Cashila] address_provider
    def sync_account(address_provider)
      response = connection(sign: true).put('/api/v1/account') do |req|
        req.body = MultiJson.dump(
          account:      {
            email: address_provider.user.email,
          },
          verification: address_provider.user_details,
        )
      end
      parse_response(response)
    end

    # @param [Hash[Symbol => String]] docs
    def upload_docs(docs)
      %i{gov-id-front gov-id-back residence}.map do |key|
        if (doc = docs[key])
          response = connection(sign: true).put("/api/v1/verification/#{key}") do |req|
            req.headers[:content_type] = 'application/octet-stream'
            req.body                   = doc
          end
          parse_response(response)
        end
      end
    end

    def verification_status
      response = connection(sign: true).get('/api/v1/verification')
      parse_response(response)
    end


    def parse_response(response)
      result = MultiJson.load(response.body)
      if (error = result['error'])
        raise ApiError.new(error)
      end
      result['result'] || result
    end

    def connection(sign: false)
      Faraday.new(connection_options) do |faraday|
        if sign
          raise InvalidCredentials unless @token && @secret
          faraday.use SigningMiddleware, @token, @secret
        end
        faraday.adapter :net_http
      end
    end

    private def connection_options
      {
        url:     @url,
        ssl:     {
          ca_path: '/usr/lib/ssl/certs',
        },
        headers: {
          content_type: 'application/json',
          'API-Client'  => @client_id,
        },
      }
    end


    class SigningMiddleware < Faraday::Middleware

      def initialize(app, token, secret)
        @app    = app
        @token  = token
        @secret = Base64.decode64(secret)
      end

      def call(env)
        env[:request_headers]['API-User']  = @token
        env[:request_headers]['API-Nonce'] = (Time.now.to_f * 1000000).to_i.to_s
        env[:request_headers]['API-Sign']  = signature(env)
        @app.call(env)
      end

      # Base64Encode(
      #   HMAC-SHA512(
      #     “PUT/v1/billpays” + SHA256(“1434363295”+”{“based_on”:123}”),
      #     Base64Decode(“secret”)
      #   )
      # )
      def signature(env)
        request = "#{env[:request_headers]['API-Nonce']}#{env[:body]}"
        request = "#{env[:method].to_s.upcase}#{URI(env[:url]).path.sub('/api', '')}#{OpenSSL::Digest::SHA256.new.digest(request)}"
        Base64.strict_encode64 OpenSSL::HMAC.digest('sha512', @secret, request)
      end
    end
  end
end
