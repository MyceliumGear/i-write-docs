require 'rails_helper'

describe UpdatesController, type: :controller do

  let(:valid_attributes) { { priority: :critical, subject: "Title", body: "Body" }  }
  describe "POST #create" do

    before(:each) do
      login_user(create(:admin))
    end

    it "creates a new UpdateItem" do
      expect {
        post :create, { update_item: valid_attributes }
      }.to change(UpdateItem, :count).by(1)
    end

    it "sends email to users" do
      level = UpdateItem.priorities[:regular]
      bob = create(:user, updates_email_subscription_level: level)

      expect(String).to receive(:hash)
      post :create, { update_item: valid_attributes }
    end

  end

end
