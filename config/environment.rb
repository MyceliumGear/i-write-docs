# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
begin
  Rails.application.initialize!
rescue Sequel::DatabaseDisconnectError
  STRAIGHT_SERVER_INITIALIZER.connect_to_db
end
