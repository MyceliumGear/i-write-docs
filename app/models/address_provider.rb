class AddressProvider < ActiveRecord::Base

  belongs_to :user

  validates :user, presence: true
  validates :type, uniqueness: {scope: :user_id, message: I18n.t("already_exists", scope: "address_provider.errors.type")}

  validate :validate_class

  def display_name
    name.presence || self.class.type
  end


  def self.type
    @type ||= name.demodulize.freeze
  end

  def self.providers
    @providers ||= [
      AddressProviders::Cashila,
    ].freeze
  end

  def self.providers_by_currency
    @providers_by_currency ||= providers.each_with_object(HashWithIndifferentAccess.new) do |provider, h|
      provider::CURRENCIES.each do |currency|
        (h[currency] ||= []) << provider
      end
    end.deep_freeze
  end

  def currencies(as: :string)
    currencies = self.class::CURRENCIES
    as == :string ? currencies.join(' ') : currencies
  end

  def self.provider_types
    @provider_types ||= providers.map(&:type).to_set.freeze
  end


  private def validate_class
    if instance_of?(AddressProvider)
      errors.add :type, :invalid
    end
  end
end
