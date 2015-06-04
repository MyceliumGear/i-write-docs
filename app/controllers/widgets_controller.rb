class WidgetsController < ApplicationController

  before_filter :authenticate_user!, except: [:show]
  before_filter :find_widget
  before_filter :check_if_gateway_owner, except: [:show]

  def update
    @widget.update(widget_params)
    @widget.reload if @widget.errors.empty?
    render 'edit', layout: false
  end

  private

    def find_widget
      if params[:id] =~ /\A[0-9]+\Z/
        @widget  = Widget.where(id: params[:id]).includes(:gateway).first
        @gateway = @widget.gateway if @widget
      else
        @gateway = Gateway.where(straight_gateway_hashed_id: params[:id]).includes(:widget).first
        @widget  = @gateway.widget if @gateway
      end
      render_404 unless @gateway || @widget
    end

    def widget_params
      params.require(:widget).permit(:fields, :variable_price, :products_to_remove_ids, widget_products_attributes: [:title, :price, :singular], product_updates: [:id, :title, :price, :singular])
    end

    def check_if_gateway_owner
      render_403 and return unless @gateway.user_id == current_user.id
    end


end
