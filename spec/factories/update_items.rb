FactoryGirl.define do
  factory :update_item do
    priority :important
    subject "TypeError"
    body "ERROR: Guard::Brakeman failed to achieve its , exception was"
  end

  factory :regular_update, class: :UpdateItem do
    subject "regular update"
    body "<i>regular update</i>"
    priority :regular
  end

  factory :important_update, class: :UpdateItem do
    subject "important update"
    body "<u>important update</u>"
    priority :important
  end

  factory :critical_update, class: :UpdateItem do
    subject "critical update"
    body "<b>critical update</b>"
    priority :critical
  end
end
