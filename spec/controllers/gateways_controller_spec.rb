require 'rails_helper'

RSpec.describe GatewaysController, type: :controller do

  describe "index action" do

    before(:each) do
      @merchant = create(:user)
      @admin    = create(:admin)
      allow(StraightServer::Gateway).to receive_message_chain('create.id').and_return(*((1..12).to_a))
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

end
