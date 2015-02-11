class Gateway < ActiveRecord::Base

  nilify_blanks

  belongs_to :user
  serialize :db_config, Hash

  validates :confirmations_required, :pubkey, :name,
            :default_currency, :check_signature, :user,
            presence: true

  validates :confirmations_requires, numericality: { greater_than_or_equal_to: 0 }
  # validate Adapter exchange_rate_adapter_names are from the available list

end
