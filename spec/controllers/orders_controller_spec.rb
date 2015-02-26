require 'rails_helper'

RSpec.describe OrdersController, type: :controller do

  describe "index action" do

    before(:each) do
      login_user
      @gateway_1, @gateway_2 = create_list(:gateway, 2, user: @current_user)
      @gateway_3             = create(:gateway)
      @orders1  = create_list(:order, 15, gateway_id: @gateway_1.straight_gateway_id)
      @orders2  = create_list(:order, 16, gateway_id: @gateway_2.straight_gateway_id)
      @orders3  = create_list(:order, 2,  gateway_id: @gateway_3.straight_gateway_id)
    end
    
    it "shows all orders for all user's gateways" do
      get :index
      expect(assigns(:orders).to_a.size).to eq(30)
    end

    it "shows all orders for a specific gateway" do
      get :index, gateway_id: @gateway_1.id
      expect(assigns(:orders).to_a.size).to eq(15) 
    end

    it "renders 403 if the specified gateway doesn't belong to the current_user and current_user is not admin" do
      get :index, gateway_id: create(:gateway).id
      expect(response).to render_403 
    end

    it "shows all orders for a specific gateway if the gateway doesn't belong to the current_user, but current_user is an admin" do
      login_user(:admin)
      get :index, gateway_id: create(:gateway).id
      expect(response).not_to render_403 
    end

    it "shows all orders for all gateways of all users to admins" do
      login_user(create(:admin))
      get :index
      expect(assigns(:orders).to_a.size).to eq(30)
      get :index, page: 2
      expect(assigns(:orders).to_a.size).to eq(3)
    end

  end

  describe "show index" do

    before(:each) do
      login_user
      @gateway = create(:gateway, user: @current_user)
      @order   = create(:order, gateway_id: @gateway.straight_gateway_id)
    end
    
    it "displays info about to order if it belongs to the gateway current_user owns" do
      get :show, id: @order.id
      expect(response).to render_template('show') 
    end

    it "displays info about to order if order belongs to gateway current_user doesn't own, but current_user is admin" do
      login_user(:admin)
      get :show, id: @order.id
      expect(response).to render_template('show') 
    end

    it "renders 403 if order belongs to gateway current_user doesn't own" do
      login_user
      get :show, id: @order.id
      expect(response).to render_403
    end

    it "renders 404 if order isn't found" do
      get :show, id: 0
      expect(response).to render_404
    end

  end

end
