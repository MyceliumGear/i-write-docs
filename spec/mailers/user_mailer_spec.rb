require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do

  it "not raise errors" do
    @user = create(:user, updates_email_subscription_level: nil)
    expect{UserMailer.update_item}.not_to raise_exception(Exception)
  end
end
