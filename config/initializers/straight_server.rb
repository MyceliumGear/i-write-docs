require 'straight-server'

StraightServer::Initializer::ConfigDir.set! "#{Rails.root}/config/straight/#{Rails.env}"
StraightServer::Initializer.new.prepare run_migrations: Rails.env.test?

if Rails.env.test?
  StraightServer::Config.gateways_source = 'db'
end
