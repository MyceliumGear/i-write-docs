FactoryGirl.define do
  factory :user do

    sequence(:name)  { |i| "Merchant User#{i}" }
    sequence(:email) { |i| "user#{i}@gearpayments.com" }
    password "password"
    
    confirmed_at Time.now
    
  end
end
