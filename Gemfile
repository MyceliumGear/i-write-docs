source 'https://rubygems.org'

gem 'rails', '4.2.0'
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
gem 'redis'
gem 'mmmenu', github: 'frootloops/mmmenu'
gem 'country_select', github: 'stefanpenner/country_select'
gem 'pg'
gem 'open_uri_redirections'
gem 'sequel'
gem 'httparty'
gem 'devise_google_authenticator'
gem 'dotenv'
gem 'sentry-raven', git: 'https://github.com/getsentry/raven-ruby.git'
gem 'roadie-rails'
gem 'sinatra', require: nil
gem 'sidekiq'

gem 'straight',        "0.2.3", path: 'vendor/gems/straight-engine', require: nil
gem 'straight-server', "0.2.3", path: 'vendor/gems/straight-server', require: nil

group :development do
  gem 'thin'
  gem 'mina'
  gem 'mina-sidekiq'
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
end

group :test do
  gem 'database_cleaner', git: 'https://github.com/tommeier/database_cleaner', branch: 'fix-superclass'
  gem 'turn', require: false # Pretty printed test output
end
