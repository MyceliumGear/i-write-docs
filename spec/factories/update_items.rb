FactoryGirl.define do
  factory :update_item do
    priority :important
    subject "TypeError"
    body "ERROR: Guard::Brakeman failed to achieve its , exception was"
  end
end
