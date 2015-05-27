require 'raven'
Raven.configure do |config|
  config.dsn = 'https://e75ae3156c2a4c2bbc8727e9b6804a6a:dcb5efcdfeaa41169f0b5fb39fa7d77b@app.getsentry.com/44779'
  config.environments = ["production", "staging"]
  config.excluded_exceptions = ['ActionController::RoutingError', 'ActiveRecord::RecordNotFound']
  config.tags = { environment: Rails.env }
  config.silence_ready = true
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s) + %w(host User-Agent)
end
