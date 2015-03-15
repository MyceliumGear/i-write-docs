class WizardController < ApplicationController

  def step
    if params[:step].to_i == 2
      @gateway = Gateway.new(site_type: params[:site_type])
      render 'step2'
    elsif params[:step].to_i == 3
      @gateway = Gateway.find(params[:gateway_id])
      render 'step3'
    else
      render 'step1'
    end
  end

  def create_gateway
    @gateway = Gateway.new(gateway_params.merge({user: current_user}))
    if @gateway.save
      flash[:gateway_secret] = @gateway.secret
      redirect_to action: :step, step: 3, gateway_id: @gateway.id
    else
      flash.now[:error] = "We've found errors in your form, please correct them and try again."
      render 'step2'
    end
  end

  private

    def gateway_params
      params.require(:gateway).permit(
        :pubkey,
        :name,
        :default_currency,
        :merchant_url,
        :site_type
      )
    end

end
