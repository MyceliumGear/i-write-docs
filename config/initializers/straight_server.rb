straight_config_dir = "#{Rails.root}/config/straight/#{Rails.env}"
straight_config_dir = "#{Rails.root}/config/straight" unless File.exists?(straight_config_dir) # deployed build needs only one config
StraightServer::Initializer::ConfigDir.set! straight_config_dir
StraightServer::Initializer.new.prepare run_migrations: Rails.env.test?

if Rails.env.test?
  StraightServer::Config.gateways_source = 'db'
end
