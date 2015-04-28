FactoryGirl.define do
  factory :widget_product do
    association :widget
    title "Some product"
    price 1.29
  end
end
