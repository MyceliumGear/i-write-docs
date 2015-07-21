FactoryGirl.define do

  factory :user do
    sequence(:name)  { |i| "Merchant User#{i}" }
    sequence(:email) { |i| "user#{i}#{Time.now.to_i}@gearpayments.com" }
    password "password"
    confirmed_at Time.now
    tos_agreement "1"
  end


  factory :admin, class: User do
    sequence(:name)  { |i| "Admin User#{i}" }
    sequence(:email) { |i| "admin#{i}#{Time.now.to_i}@gearpayments.com" }
    password "password"
    confirmed_at Time.now
    role 'admin'
    tos_agreement "1"
  end

end
