require 'rails_helper'

describe User, type: :model do

  describe ".roles" do
    it "returns current collection" do
      expect(User.roles).to eql({ "merchant" => 0, "admin" => 1 })
    end
  end

  describe "#admin?" do
    it "returns true when user has admin role" do
      user = User.new(role: :admin)
      expect(user).to be_admin
    end

    it "returns false when user hasn't admin role" do
      user = User.new(role: :merchant)
      expect(user).to_not be_admin
    end
  end

end
