class GatewaysController < ApplicationController

  before_filter :authenticate_user!

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
  end
  
  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
