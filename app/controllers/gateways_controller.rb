class GatewaysController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_gateway, only: [:show, :edit, :update, :destroy]

  def index
    @gateways = Gateway.order('created_at DESC')
    unless current_user.admin?
      @gateways = @gateways.where(user_id: current_user.id)
    end
    @gateways = @gateways.paginate(page: params[:page], per_page: 10)
  end

  def new
  end

  def create
    @gateway = Gateway.new(gateway_params.merge({user: current_user}))
    if @gateway.save
      redirect_to gateways_path
    else
      render 'new'
    end
  end
  
  def show
  end

  def edit
  end

  def update
    @gateway.update_attributes(gateway_params)
    if @gateway.errors.empty?
      redirect_to gateways_path
    else
      render 'edit'
    end
  end

  def destroy
  end


  private

    def find_gateway
      @gateway = Gateway.find(params[:id])
    end

    def gateway_params
      params.require(:gateway).permit(
        :confirmations_required,
        :pubkey,
        :name,
        :default_currency,
        :callback_url,
        :check_signature,
        :active,
        :exchange_rate_adapter_names,
        :description,
        :merchant_url,
        :merchant_name,
        :country,
        :region,
        :city,
        :db_config
      )
    end

end
