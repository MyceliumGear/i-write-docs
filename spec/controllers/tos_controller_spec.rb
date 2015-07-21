require 'rails_helper'

RSpec.describe TosController, type: :controller do

  describe "index action" do

    it "show tos page w/o authorization" do
      get :index
      expect(response).to have_http_status(:success)
    end

  end

end
