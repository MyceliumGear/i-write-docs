source 'https://rubygems.org'

gem 'rails', '4.2.0'
gem 'sqlite3'
gem 'haml-rails'
gem 'devise'
gem 'simple_form'
gem 'meta-tags', require: 'meta_tags'
gem 'exception_notification', git: 'https://github.com/smartinez87/exception_notification'
gem 'jquery-rails'
gem 'string_master'
gem 'will_paginate'
gem 'frontend_notifier'
gem 'nilify_blanks'
gem 'redis'
gem 'mmmenu'
gem 'country_select', github: 'stefanpenner/country_select'
gem 'pg'
gem 'open_uri_redirections'
gem 'sequel'
gem 'httparty'
gem 'dotenv'

gem 'straight',        path: 'vendor/gems/straight-engine'
gem 'straight-server', path: 'vendor/gems/straight-server'

group :development do
  gem 'thin'
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
