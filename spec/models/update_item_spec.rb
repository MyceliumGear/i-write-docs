require 'rails_helper'

describe UpdateItem, type: :model do

  describe ".priorities" do
    it "returns default value" do
      expect(UpdateItem.new.priority).to eql("regular")
    end

    it "returns correct collection" do
      priorities = { "regular" => 0, "important" => 1, "critical" => 2 }
      expect(UpdateItem.priorities).to eql(priorities)
    end
  end

end
