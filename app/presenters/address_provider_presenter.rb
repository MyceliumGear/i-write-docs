class AddressProviderPresenter < SimpleDelegator

  def initialize(obj, user)
    @current_user = user
    super(obj)
  end

  def new_payout_link_classes
    if AddressProvider.providers.sort.eql? @current_user.address_providers.collect(&:class).sort
      'button small disabled'
    else
      'button small'
    end
  end

  private

    def object
      __getobj__
    end

end
