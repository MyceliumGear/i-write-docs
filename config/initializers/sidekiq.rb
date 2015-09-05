Sidekiq.configure_server do |config|
  Rails.logger = Sidekiq::Logging.logger = LogStashLogger.new(type: :redis, uri: ENV['REDIS_URL'], list: 'logstash_admin-sidekiq')
end
