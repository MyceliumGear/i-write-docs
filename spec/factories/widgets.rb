FactoryGirl.define do
  factory :widget do
    initialize_with { create(:widget_gateway).widget }
  end
end
