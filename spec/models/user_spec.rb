require 'rails_helper'

describe User, type: :model do

  context "roles" do
    it "returns current collection" do
      expect(User.roles).to eql({ "merchant" => 0, "admin" => 1 })
    end
  end

  describe "when asked if admin" do
    it "returns true when user has admin role" do
      user = User.new(role: :admin)
      expect(user).to be_admin
    end

    it "returns false when user hasn't admin role" do
      user = User.new(role: :merchant)
      expect(user).to_not be_admin
    end
  end

  describe "#updates_email_subscription_level" do

    it "is valid only within [nil] + UpdateItem.priorities " do
      user = build(:user)
      ([nil] + UpdateItem.priorities.values).each do |level|
        user.updates_email_subscription_level = level
        expect(user).to be_valid
      end

      user.updates_email_subscription_level = UpdateItem.priorities.values.last + 1
      expect(user).to_not be_valid
    end

  end

end
