require 'rails_helper'

RSpec.describe GatewaysController, type: :controller do

  before(:each) do
    allow(StraightServer::Gateway).to receive_message_chain('create.id').and_return(*((1..100).to_a))
    allow_any_instance_of(Gateway).to receive_message_chain('straight_gateway.update')
    login_user
  end

  describe "index action" do

    before(:each) do
      @merchant = create(:user)
      @admin    = create(:admin)
      @merchant_gateways = create_list(:gateway, 5, user: @merchant)
      @other_gateways    = create_list(:gateway, 7)
    end

    it "shows all gateways belonging to the current user, paginated" do
      login_user(@merchant)
      get :index
      expect(response).to render_template('index')
      expect(assigns(:gateways).size).to eq(5)
    end

    it "shows all gateways of all users to admins" do
      login_user(@admin)
      get :index
      expect(response).to render_template('index')
      expect(assigns(:gateways).size).to eq(10) 
    end

  end

  describe "create action" do

    it "redirects to the gateway's index page if validations pass" do
      post :create, gateway: attributes_for(:gateway)
      expect(response).to redirect_to(gateways_path)
    end

    it "renders the form again if validations fail" do
      post :create, gateway: attributes_for(:gateway).merge({name: nil})
      expect(response).to render_template('new')
    end

  end

  describe "update action" do

    before(:each) do
      @gateway = create(:gateway, user: @current_user)
    end

    it "redirects to the gateway's index page if validations pass" do
      patch :update, id: @gateway.id, gateway: { name: "New Gateway Name" }
      expect(response).to redirect_to(gateways_path)
    end

    it "renders the form again if validations fail" do
      patch :update, id: @gateway.id, gateway: { name: nil }
      expect(response).to render_template('edit')
    end

  end

end
