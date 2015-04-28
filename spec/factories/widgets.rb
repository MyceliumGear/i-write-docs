FactoryGirl.define do
  factory :widget do
    association :gateway
    fields "*address,name,*email"
  end
end
