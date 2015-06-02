class ApplicationMailer < ActionMailer::Base
  default from: "info@gear.mycelium.com"
  layout 'email'
end
