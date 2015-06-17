require 'cashila_api'

module AddressProviders
  class Cashila < AddressProvider

    CURRENCIES = ['EUR'].deep_freeze

    USER_DETAILS = %i{
      first_name
      last_name
      address
      postal_code
      city
      country_code
    }.freeze
    store_accessor :user_details, USER_DETAILS

    FILES = %i{
      gov-id-front
      gov-id-back
      residence
    }.freeze
    attr_accessor :files # Hash[Symbol => IO]

    store_accessor :credentials, %i{
      token
      secret
    }

    # @return [Hash] main keys: 'status', 'rejected_reason'
    def actual_state
      api_client.verification_status
    end

    def sync_and_save
      validate!
      sync_account
      save!
    end


    def sync_account
      client = api_client
      if token.blank? || secret.blank?
        self.credentials = client.request_signup
      end
      client.sync_account(self)
      docs = files.present? && FILES.each_with_object({}) do |k, h|
        next unless (file = files[k])
        h[k] = file.read
      end
      debugger
      client.upload_docs(docs) unless docs.blank?
    end

    def api_client
      CashilaAPI::Client.new(
        token:     token.presence,
        secret:    secret.presence,
        client_id: Rails.application.secrets.cashila_client_id,
        url:       Rails.application.secrets.cashila_url,
      )
    end


    def sync_credentials(gateway)
      record = Credentials[gateway_id: gateway.straight_gateway_id] || Credentials.new(gateway_id: gateway.straight_gateway_id)
      record.credentials = credentials
      record.save
    end

    # copy-pasted from address-providers/cashila/lib/credentials
    class Credentials < Sequel::Model(:cashila)

      plugin :timestamps, create: :created_at, update: :updated_at
      plugin :serialization

      serialize_attributes :marshal, :credentials

    end
  end
end
