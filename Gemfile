source 'https://rubygems.org'

gem 'rails', '4.2.3'
gem 'sqlite3'
gem 'haml-rails'
gem 'devise'
gem 'simple_form'
gem 'meta-tags', require: 'meta_tags'
gem 'jquery-rails'
gem 'string_master'
gem 'will_paginate'
gem 'frontend_notifier'
gem 'nilify_blanks'
gem 'ice_nine', require: ['ice_nine', 'ice_nine/core_ext/object']
gem 'redis'
gem 'mmmenu', github: 'snitko/mmmenu'
gem 'country_select', github: 'stefanpenner/country_select'
gem 'pg'
gem 'open_uri_redirections'
gem 'sequel'
gem 'httparty'
gem 'faraday'
gem 'devise_google_authenticator'
gem 'dotenv'
gem 'envied'
# gem 'sentry-raven', github: 'getsentry/raven-ruby'
gem 'roadie-rails'
gem 'sinatra', require: nil
gem 'sidekiq'
gem 'sidetiq'
gem 'cashila-api', github: 'MyceliumGear/cashila-api'
gem 'kramdown'
gem 'coderay'
gem 'iban-tools', github: 'Absolight/iban-tools'
gem 'bic_validation'
gem 'jwt'
gem 'lograge'
gem 'logstash-logger'

gem 'puma'
gem 'rake'

if ENV['BUILD_ROOT'].to_s.empty?
  gem 'straight',        "1.0.0", path: 'vendor/gems/straight-engine'
  gem 'straight-server', "1.0.0", path: 'vendor/gems/straight-server'
else
  gem 'straight', git: "#{ENV['BUILD_ROOT']}/straight/.git", ref: ENV['STRAIGHT_REF']
  gem 'straight-server', git: "#{ENV['BUILD_ROOT']}/straight-server/.git", ref: ENV['STRAIGHT_SERVER_REF']
end


group :development do
  gem 'mina'
  gem 'mina-sidekiq'
  gem 'slack-notifier'
end

group :assets do
  gem 'sass-rails', '~> 4.0.3'
  gem 'uglifier', '>= 1.3.0'
end

group :development, :test do
  gem 'byebug'
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'rspec-rails'
  gem 'rspec-collection_matchers'
  gem 'factory_girl_rails'
  gem 'whiny_validation'
  gem 'i18n-tasks', '~> 0.8.3'
end

group :test do
  gem 'simplecov', require: false
  gem 'webmock', require: false
  gem 'vcr', require: false
  gem 'database_cleaner', github: 'tommeier/database_cleaner', branch: 'fix-superclass', require: false
  gem 'timecop', require: false
  gem 'turn', require: false # Pretty printed test output
end
