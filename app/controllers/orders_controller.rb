class OrdersController < ApplicationController

  before_filter :authenticate_user!

  def index

    gateway_ids = if params[:gateway_id]
      gateway = Gateway.find(params[:gateway_id])
      render_403 and return unless gateway.user == current_user || current_user.admin?
      [gateway.id]
    else
      current_user.gateways.map(&:id) unless current_user.admin?
    end

    @orders = StraightServer::Order.where() # because #extension method below can only be called on Dataset obj
    @orders = @orders.where(gateway_id: gateway_ids) if gateway_ids
    @orders = @orders.extension(:pagination).paginate(params[:page].try(:to_i) || 1, 30)

  end

end
