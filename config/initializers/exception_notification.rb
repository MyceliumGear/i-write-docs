if Rails.env == "production" || Rails.env == "staging"

  exceptions = []
  exceptions << 'ActiveRecord::RecordNotFound'
  exceptions << 'AbstractController::ActionNotFound'
  exceptions << 'ActionController::RoutingError'
  exceptions << 'ActionController::InvalidAuthenticityToken'

  server_name = case Rails.env
    when "production"     then "admin.gearpayments.com"
    when "staging"        then "admin.stage.gearpayments.com"
    when "development"    then "LOCALHOST admin gearpayments"
    else
      "unknown env gearpayments.com"
  end

  GearAdmin::Application.config.middleware.use ExceptionNotification::Rack,
      email: {
        email_prefix:   "[#{server_name} error] ",
        sender_address: "error500@gearpayments.com",
        exception_recipients: ADMIN_EMAILS
      },
      ignore_exceptions: exceptions

end
