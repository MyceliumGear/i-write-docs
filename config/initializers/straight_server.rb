require 'sequel'
require 'straight'
require 'logmaster'
require 'openssl'
require 'base64'
require 'straight-server'

# Connect to straght's DB before loading the models
class StraightServerInitializer
  include StraightServer::Initializer
end
StraightServer::Initializer::ConfigDir.set!("#{Rails.root}/config/straight/#{Rails.env}")
STRAIGHT_SERVER_INITIALIZER = StraightServerInitializer.new
STRAIGHT_SERVER_INITIALIZER.read_config_file

db = STRAIGHT_SERVER_INITIALIZER.connect_to_db
db.extension(:connection_validator)
db.pool.connection_validation_timeout = 600

STRAIGHT_SERVER_INITIALIZER.setup_redis_connection

if Rails.env.test?
  STRAIGHT_SERVER_INITIALIZER.run_migrations
  StraightServer::Config.gateways_source = "db"
end

require 'straight-server/order'
require 'straight-server/gateway'
