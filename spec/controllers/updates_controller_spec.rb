require 'rails_helper'

describe UpdatesController, type: :controller do

  describe "GET #index" do

    it "changes last_read_update_id" do
      update_id = create(:update_item, priority: :important).id
      user = create(:user)
      login_user(user)

      get :index

      expect(user.reload.last_read_update_id).to eql(update_id)
    end

  end

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

  end

  describe "POST #delivery" do

    before(:each) do
      login_user(create(:admin, updates_email_subscription_level: nil))
    end

    it "sends email to users" do
      update = create(:update_item, priority: :important)
      create(:user, updates_email_subscription_level: UpdateItem.priorities[:regular])
      create(:user, updates_email_subscription_level: UpdateItem.priorities[:important])
      create(:user, updates_email_subscription_level: UpdateItem.priorities[:critical])

      expect(UserMailer).to receive(:update_item)
        .with(kind_of(User), kind_of(UpdateItem)).twice.and_call_original

      post :delivery, id: update.id
      expect(update.reload.sent_at).to_not be_nil
    end

    context "update was already send" do

      it "returns notice" do
        update_id = create(:update_item, priority: :important, sent_at: Time.now).id

        expect(UserMailer).to_not receive(:update_item)

        post :delivery, id: update_id
      end

    end

  end

end
