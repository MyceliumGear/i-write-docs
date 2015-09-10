class AddressProvidersController < ApplicationController

  before_action :authenticate_user!
  before_action :find_address_provider, only: %i{show edit update destroy}

  rescue_from InvalidAddressProviderType = Class.new(ArgumentError), with: -> { redirect_to address_providers_path }

  def index
    @address_providers =
      if @current_user.admin?
        AddressProvider.includes(:user).all
      else
        @current_user.address_providers
      end.paginate(page: params[:page].try(:to_i) || 1)
    @allow_new_entries = AddressProvider.providers.sort.eql? User.last.address_providers.collect(&:class).sort
    unless @address_providers.present?
      redirect_to new_address_provider_url
    end
  end

  def show
    @actual_state = @address_provider.actual_state
  end

  def new
  end

  def create
    klass                  = address_provider_class
    @address_provider      = klass.new(permitted_params(klass))
    @address_provider.user = @current_user
    on_error = -> do
      if @address_provider.persisted?
        session["address_provider_partially_created_#{@address_provider.id}"] = true
        render(:edit)
      else
        render(:new)
      end
    end
    begin
      @address_provider.sync_and_save
      flash[:success] = I18n.t("address_providers_controller.exchange.successfully.created")
      redirect_to address_provider_path(@address_provider)
    rescue ActiveRecord::RecordInvalid
      # form will render errors
      on_error.call
    rescue => ex
      flash.now[:error] = ex.message
      on_error.call
    end
  end

  def edit
  end

  def update
    @address_provider.assign_attributes(permitted_params(@address_provider.class))
    begin
      @address_provider.sync_and_save
      if session.delete("address_provider_partially_created_#{@address_provider.id}")
        flash[:success] = I18n.t("address_providers_controller.exchange.successfully.created")
      else
        flash[:success] = I18n.t("address_providers_controller.exchange.successfully.updated")
      end
      redirect_to address_provider_path(@address_provider)
    rescue ActiveRecord::RecordInvalid
      # form will render errors
      render :edit
    rescue => ex
      flash.now[:error] = ex.message
      render :edit
    end
  end

  # def destroy
  #   if @address_provider.destroy
  #     flash[:notice] = I18n.t(address_providers_controller.exchange.successfully.deleted", name: @address_provider.display_name)
  #   end
  #   redirect_to address_providers_path
  # end


  private def address_provider_class
    raise InvalidAddressProviderType unless AddressProvider.provider_types.include?(params[:type])
    "AddressProviders::#{params[:type]}".constantize
  end

  private def find_address_provider
    @address_provider =
      if current_user.admin?
        AddressProvider
      else
        current_user.address_providers
      end.find(params[:id])
  end

  private def permitted_params(klass)
    if klass == AddressProviders::Cashila
      required = params.require(:address_providers_cashila)
      required.permit(
        :name,
        *AddressProviders::Cashila::USER_DETAILS,
        files: AddressProviders::Cashila::FILES,
      )
    end
  end
end
