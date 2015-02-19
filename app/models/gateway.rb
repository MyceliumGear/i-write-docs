class Gateway < ActiveRecord::Base

  nilify_blanks

  belongs_to :user
  serialize :db_config, Hash
  serialize :exchange_rate_adapter_names

  validates :confirmations_required, :pubkey, :name,
            :default_currency, :check_signature, :user,
            presence: true

  validates :confirmations_required, numericality: { greater_than_or_equal_to: 0 }

  before_validation :split_exchange_rate_adapter_names!
  validate          :validate_exchange_rate_adapter_names, if: 'self.exchange_rate_adapter_names.present?'

  private

    def validate_exchange_rate_adapter_names
      self.exchange_rate_adapter_names = self.exchange_rate_adapter_names.map do |a|
        begin
          Kernel.const_get("Straight::ExchangeRate::#{a}Adapter")
        rescue
          errors.add(:exchange_rate_adapter_names, "includes adapter #{a}Adapter which is not available")
        end
      end
    end

    def split_exchange_rate_adapter_names!
      if self.exchange_rate_adapter_names.kind_of?(String)
        self.exchange_rate_adapter_names = self.exchange_rate_adapter_names.split(/,\s*/)
      end
    end
  
end
