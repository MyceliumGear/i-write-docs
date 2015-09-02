require 'rails_helper'

RSpec.describe GatewaysController, type: :controller do

  it_should_require_signed_in_user [:index, :new, :show, :edit, :update, :destroy], :gateway
  it_should_render_404_if_the_resource_was_not_found [:show, :edit, :update, :destroy]
  it_only_allows_resource_author_or_admin            [:show, :edit, :update, :destroy], :gateway

  before(:each) do
    login_user
  end

  describe "index action" do

    before(:each) do
      @merchant = create(:user)
      @admin    = create(:admin)
      @merchant_gateways = create_list(:gateway, 5, user: @merchant)
      create(:gateway, deleted: true, user: @merchant)
      @other_gateways    = create_list(:gateway, 7)
    end

    it "shows all gateways belonging to the current user, paginated (excluding deleted ones)" do
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

    it "finds gateways that are widgets" do
      login_user(@merchant)
      create_list(:gateway, 2, user: @merchant, site_type: 'Wordpress')
      get :index, widget: 1
      expect(response).to render_template('index')
      expect(assigns(:gateways).size).to eq(2)
    end

  end

  describe "create action" do

    it "redirects to the gateway's index page if validations pass" do
      post :create, gateway: attributes_for(:gateway)
      expect(response).to redirect_to(assigns(:gateway))
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
      expect(response).to redirect_to(assigns(:gateway))
    end

    it "renders the form again if validations fail" do
      patch :update, id: @gateway.id, gateway: { name: nil }
      expect(response).to render_template('edit')
    end

  end

  describe "show action" do

    before(:each) do
      @gateway = create(:gateway, user: @current_user)
    end

    it "show gateway without any parameters" do
      get :show, id: @gateway.id
      expect(response).to render_template('show')
    end

    it "show gateway with show_addresses parameter" do
      get :show, id: @gateway.id, show_addresses: 1..15
      expect(response).to render_template('show')
    end

    it "show gateway with invalid show_addresses parameter" do
      get :show, id: @gateway.id, show_addresses: -1..15
      expect(response).to render_template('show')
    end

  end

  describe "destroy action" do
    
    it "marks gateway as deleted" do
      gateway = create(:gateway, user: @current_user)
      delete :destroy, id: gateway.id
      expect(response).to redirect_to(gateways_path) 
    end

  end

end
