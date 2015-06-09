class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.secrets.mailer_sender
  layout 'email'
end
