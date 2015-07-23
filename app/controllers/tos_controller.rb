class TosController < ApplicationController
  def index
    @gateway_url = APP_ENV['gateway_host'] || 'https://gear.mycelium.com/'
  end
end
