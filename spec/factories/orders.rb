FactoryGirl.define do

  factory :order, class: StraightServer::Order do
    sequence(:id)          { |i| i }
    sequence(:keychain_id) { |i| i }
    sequence(:address)     { |i| "address_#{i}" }
    amount 10
    to_create { |order| order.save }
  end

  factory :straight_order, class: Sequel::Model(:orders) do
    created_at             { Time.now }
    sequence(:id)          { |i| i }
    sequence(:keychain_id) { |i| i }
    sequence(:address)     { |i| "address_#{i}" }
    sequence(:payment_id)  { |i| "payment_#{i}" }
    amount 1
    to_create { |order| order.save }
  end
end
