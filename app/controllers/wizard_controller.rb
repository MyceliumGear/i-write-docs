class WizardController < ApplicationController

  def step
    if params[:step].to_i == 2
      @gateway = Gateway.new(site_type: params[:site_type], default_currency: 'USD')
      render 'step2'
    elsif params[:step].to_i == 3
      @gateway = Gateway.where(id: params[:gateway_id]).includes(:widget).first
      render_404 and return unless @gateway
      @widget  = @gateway.widget
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

  RESPONSE_LIMIT = 3.megabytes
  def detect_site_type
    url      = params[:url]
    url      = url.match(/\Ahttps?:\/\//) ? url : "http://" + url
    url.chomp!('/')
    begin
      file     = open(url, allow_redirections: :all, progress_proc: lambda { |size| raise if size > RESPONSE_LIMIT })
      contents = file.read
    rescue
      render text: 'connectionError' and return
    end

    if contents.match('<meta name="generator" content="WordPress')
      render text: "wordpress"
    elsif contents.match('<meta name="generator" content="Joomla')
      render text: 'joomla'
    else
      #begin
        #if open(url + '/wp-admin', allow_redirections: :all).status == ["200", "OK"]
          #render text: "wordpress" and return
        #end
      #rescue
         #continue
      #end
      render text: "unknown"
    end
  end

  private

    def gateway_params
      params.require(:gateway).permit(
        :pubkey,
        :name,
        :default_currency,
        :merchant_url,
        :site_type,
        :receive_payments_notifications,
      )
    end

end
