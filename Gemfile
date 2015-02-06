source 'https://rubygems.org'

gem 'rails', '4.2.0'
gem 'sqlite3'
gem 'sequel'
gem 'haml-rails'
gem 'devise'
gem 'simple_form'
gem 'meta-tags', require: 'meta_tags'
gem 'exception_notification', git: 'git://github.com/smartinez87/exception_notification.git'
gem 'jquery-rails'
gem 'string_master'
gem 'will_paginate'
gem 'frontend_notifier'

group :development do
  gem 'capistrano-rails'
  gem 'thin'
  gem 'faker'
end

group :assets do
  gem 'sass-rails', '~> 4.0.3'
  gem 'uglifier', '>= 1.3.0'
end

group :development, :test do
  gem 'byebug'
  gem 'web-console', '~> 2.0'
  gem 'spring'
end

group :test do
  gem 'rspec-rails'
  gem 'rspec-collection_matchers'
  gem 'factory_girl_rails'
  gem 'database_cleaner', git: 'https://github.com/tommeier/database_cleaner', branch: 'fix-superclass' 
  gem 'turn', require: false # Pretty printed test output
end
