class AddressProviderPresenter < SimpleDelegator

  def initialize(address_providers, user)
    @current_user = user
    super(address_providers)
  end

  def allows_new_entries?
    AddressProvider.providers.sort == @current_user.address_providers.map(&:class).sort
  end

end
