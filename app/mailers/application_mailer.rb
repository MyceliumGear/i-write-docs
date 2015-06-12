class ApplicationMailer < ActionMailer::Base
  include Roadie::Rails::Automatic
  helper ApplicationHelper

  default from: Rails.application.secrets.mailer_sender
  layout 'email'

  private def roadie_options
    super unless Rails.env.test?
  end
end
