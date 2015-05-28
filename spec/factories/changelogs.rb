FactoryGirl.define do
  factory :changelog do
    priority :important
    subject "TypeError"
    body "ERROR: Guard::Brakeman failed to achieve its , exception was"
  end
end
