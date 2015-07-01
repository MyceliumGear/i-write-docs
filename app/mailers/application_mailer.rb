class ApplicationMailer < ActionMailer::Base
  include Roadie::Rails::Automatic
  helper ApplicationHelper

  append_view_path Rails.root.join("app", "views", "mailers")
  default :template_path => proc {"#{self.class.name.underscore.sub('_mailer', '')}"}
  default from: Rails.application.secrets.mailer_sender
  layout 'email'

  private def roadie_options
    super unless Rails.env.test?
  end
end
