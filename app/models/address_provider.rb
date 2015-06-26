class AddressProvider < ActiveRecord::Base

  belongs_to :user

  validates :user, presence: true

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

  def self.provider_types
    @provider_types ||= providers.map(&:type).to_set.freeze
  end
end
