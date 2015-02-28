class GatewaysController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_gateway,                      only: [:show, :edit, :update, :destroy]
  before_filter :only_allow_gateway_owner_or_admin, only: [:show, :edit, :update, :destroy]

  def index
    @gateways = Gateway.where(deleted: false).includes(:user).order('created_at DESC')
    unless current_user.admin?
      @gateways = @gateways.where(user_id: current_user.id)
    end
    @gateways = @gateways.paginate(page: params[:page], per_page: 10)
  end

  def new
    @gateway = Gateway.new
  end

  def create
    @gateway = Gateway.new(gateway_params.merge({user: current_user}))
    if @gateway.save
      flash[:gateway_secret] = @gateway.secret
      redirect_to @gateway
    else
      flash.now[:error] = "We've found errors in your form, please correct them and try again."
      render 'new'
    end
  end
  
  def show
  end

  def edit
  end

  def update
    @gateway.update(gateway_params)
    if @gateway.errors.empty?
      if @gateway.regenerate_secret
        flash[:gateway_secret] = @gateway.secret
      else
        flash[:success] = "Gateway settings updated!"
      end
      redirect_to @gateway
    else
      flash.now[:error] = "We've found errors in your form, please correct them and try again."
      render 'edit'
    end
  end

  def destroy
    @gateway.update(deleted: true)
    redirect_to gateways_path
  end


  private

    def find_gateway
      @gateway = Gateway.find(params[:id])
    end

    def only_allow_gateway_owner_or_admin
      render_403 unless current_user.admin? || @gateway.user == current_user
    end

    def gateway_params
      params.require(:gateway).permit(
        :confirmations_required,
        :pubkey,
        :name,
        :default_currency,
        :callback_url,
        :active,
        :exchange_rate_adapter_names,
        :description,
        :merchant_url,
        :country,
        :region,
        :city,
        :regenerate_secret,
        :widget
      )
    end

end
