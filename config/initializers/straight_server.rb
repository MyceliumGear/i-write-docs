require 'sequel'
require 'straight'
require 'logmaster'
require 'openssl'
require 'base64'
Sequel.extension :migration

require 'straight-server/utils/hash_string_to_sym_keys'
require 'straight-server/random_string'
require 'straight-server/config'
require 'straight-server/initializer'

# Connect to straght's DB before loading the models
class StraightServerInitializer
  include StraightServer::Initializer
end
StraightServer::Initializer::ConfigDir.set!("#{Rails.root}/config/straight")
STRAIGHT_SERVER_INITIALIZER = StraightServerInitializer.new
STRAIGHT_SERVER_INITIALIZER.read_config_file
STRAIGHT_SERVER_INITIALIZER.connect_to_db

require 'straight-server/order'
require 'straight-server/gateway'
