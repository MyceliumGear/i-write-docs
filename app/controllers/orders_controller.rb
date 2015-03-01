class OrdersController < ApplicationController

  before_filter :authenticate_user!

  def index

    @gateways = if params[:gateway_id]
      @gateway = Gateway.find(params[:gateway_id])
      render_403 and return unless @gateway.user == current_user || current_user.admin?
      [@gateway]
    else
      current_user.gateways unless current_user.admin?
    end

    @orders = StraightServer::Order.reverse_order(:created_at)
    @orders = @orders.where(gateway_id: @gateways.map(&:straight_gateway_id)) if @gateways
    @orders = @orders.where(status: params[:status]) if params[:status]
    @orders = @orders.extension(:pagination).paginate(params[:page].try(:to_i) || 1, 30)

    if current_user.admin? && params[:gateway_id].blank?
      @gateway_ids = Gateway.where(straight_gateway_id: @orders.map(&:gateway_id))
    end

    if @gateways
      @gateway_names_and_ids = {}
      @gateways.each { |g| @gateway_names_and_ids[g.id] == g.name }
    end

  end

  def show
    @gateway = Gateway.find(params[:gateway_id])
    render_403 and return unless @gateway.user == current_user || current_user.admin?

    @order = StraightServer::Order.where(keychain_id: params[:id], gateway_id: @gateway.straight_gateway_id).first
    render_404 and return unless @order
    render_403 and return unless @order.gateway_id == @gateway.straight_gateway_id
  end

end
