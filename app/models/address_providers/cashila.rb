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
      recipient_name
      recipient_address
      recipient_postal_code
      recipient_city
      recipient_country_code
      recipient_bic
      recipient_iban
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
      recipient_id
    }

    # @return [Hash] main keys: 'status', 'rejected_reason'
    def actual_state
      result = api_client.verification_status
      if recipient_id
        recipient = api_client.get_recipient(recipient_id)
        recipient.each do |k, v|
          result["recipient_#{k}"] = v
        end
      end
      result
    end

    def sync_and_save
      validate!
      sync_account
      save!
      upload_docs
      self.recipient_id = api_client.sync_recipient(recipient_details)
      save!
    end


    def sync_account
      if token.blank? || secret.blank?
        self.credentials = api_client.request_signup
      end
      api_client.sync_account(email: user.email, details: user_details)
    rescue CashilaAPI::Client::ApiError => ex
      if ex.message == 'User already exist'
        errors.add :type, "Cashila account with the #{user.email} email already exist. Unfortunately, we cannot use it. You can change your email in the account details and submit this form again."
        raise ActiveRecord::RecordInvalid.new(self)
      else
        raise
      end
    end

    def upload_docs
      docs = files.present? && FILES.each_with_object({}) do |k, h|
        next unless (file = files[k])
        h[k] = file.read
      end
      api_client.upload_docs(docs) unless docs.blank?
    end

    def api_client
      CashilaAPI::Client.new(
        token:     token.presence,
        secret:    secret.presence,
        client_id: Rails.application.secrets.cashila_client_id,
        url:       Rails.env.production? ? CashilaAPI::PRODUCTION_URL : CashilaAPI::TEST_URL,
      )
    end


    def sync_credentials(gateway)
      record             = Credentials[gateway_id: gateway.straight_gateway_id] || Credentials.new(gateway_id: gateway.straight_gateway_id)
      record.credentials = credentials
      record.save
    end

    def recipient_details
      result      = HashWithIndifferentAccess.new
      result[:id] = recipient_id if recipient_id
      (user_details || []).each do |k, v|
        if (k = k.to_s).start_with?('recipient_')
          result[k.sub('recipient_', '')] = v
        end
      end
      result
    end

    # copy-pasted from address-providers/cashila/lib/credentials
    class Credentials < Sequel::Model(:cashila)

      plugin :timestamps, create: :created_at, update: :updated_at
      plugin :serialization

      serialize_attributes :marshal, :credentials

    end
  end
end
