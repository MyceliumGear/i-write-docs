require File.expand_path('../boot', __FILE__)

require 'rails/all'

require 'dotenv'
Dotenv.load ".env.#{Rails.env}.local", ".env.#{Rails.env}", '.env'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GearAdmin
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.generators do |g|
      g.template_engine     :haml
      g.test_framework      :rspec,        fixtures: true, views: false
      g.fixture_replacement :factory_girl, dir: "spec/factories"
    end

    config.to_prepare do
      Devise::Mailer.instance_exec do
        layout "email"
        default from: Rails.application.secrets.mailer_sender
      end
    end

    config.active_job.queue_adapter = :sidekiq

    config.assets.precompile << /(^[^_\/]|\/[^_])[^\/]*$/
    config.assets.logger = nil

    config.autoload_paths += Dir[Rails.root.join('app', 'models', '{**}')]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.action_view.raise_on_missing_translations = false
    config.i18n.available_locales = [:en, :de]
    config.i18n.default_locale = :en

    ::ADMIN_EMAILS  = File.readlines("#{Rails.root}/config/admin_emails.txt").map { |e| e.strip }
    ::APP_ENV = YAML::load_file("#{Rails.root}/config/environment.yml")

    require 'will_paginate/sequel'
    require 'will_paginate/active_record'
  end
end
