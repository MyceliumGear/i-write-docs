require 'rails_helper'

RSpec.describe SubscriptionController, type: :controller do

  describe "/users/subscribition" do

    let(:secret) { Rails.application.secrets.jwt_secret }
    let(:user) { create(:user, updates_email_subscription_level: nil) }
    let(:token) { JWT.encode({ email: user.email, exp: Time.now.to_i + 1 * 3600 }, secret, 'HS256') }

    it "should redirect to login page if token invalid" do
      get :edit, { token: JWT.encode({ email: user.email }, rand(36**16).to_s(36), 'HS256') }

      expect(response).to redirect_to(new_user_session_path)
    end

    it "should redirect to login page if token not present" do
      get :edit

      expect(response).to redirect_to(new_user_session_path)
    end

    it "should redirect to login page it token expired" do
      get :edit, { token: JWT.encode({ email: user.email, exp: Time.now.to_i - 1 * 3600 }, secret, 'HS256')}

      expect(response).to redirect_to(new_user_session_path)
    end

    it "should be accessible w/o auth" do
      get :edit, { token: token }

      expect(response).to render_template("subscription/edit")
    end

    it "should be editable w/o auth" do
      update_status = UpdateItem.priorities.values.sample
      post :update, {
        token: token,
        user: {
         updates_email_subscription_level: update_status
         }
        }
      expect(User.find_by_email(user.email).updates_email_subscription_level).to eq(update_status)
    end

  end

end
