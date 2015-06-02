class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@gearpayments.com'
  layout 'email'
end
