require 'rails_helper'

describe User, type: :model do

  context "roles" do
    it "returns current collection" do
      expect(User.roles).to eql({ "merchant" => 0, "admin" => 1 })
    end
  end

  describe ".subscribed_to" do

    let(:regular_value) { UpdateItem.priorities[:regular] }
    let(:important_value) { UpdateItem.priorities[:important] }
    let(:critical_value) { UpdateItem.priorities[:critical] }

    it "returns users with subscription_level <= value" do
      create(:user, updates_email_subscription_level: regular_value)
      create(:user, updates_email_subscription_level: important_value)
      create(:user, updates_email_subscription_level: critical_value)

      expect(User.subscribed_to(:regular).count).to eql(1)
      expect(User.subscribed_to(:important).count).to eql(2)
      expect(User.subscribed_to(:critical).count).to eql(3)
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
