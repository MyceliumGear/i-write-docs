FactoryGirl.define do

  factory :user do
    sequence(:name)  { |i| "Merchant User#{i}" }
    sequence(:email) { |i| "user#{i}@gearpayments.com" }
    password "password"
    confirmed_at Time.now
  end


  factory :admin, class: User do
    sequence(:name)  { |i| "Admin User#{i}" }
    sequence(:email) { |i| "admin#{i}@gearpayments.com" }
    password "password"
    confirmed_at Time.now
    role 'admin'
  end

end
