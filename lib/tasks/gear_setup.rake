require 'active_record'

namespace :gear do
  task :setup do
    # implies that straight-server uses the same database server
    config = ActiveRecord::ConnectionAdapters::ConnectionSpecification::Resolver.new({}).resolve('url' => ENV['DATABASE_URL'])
    config['database'] = "straight_server_#{ENV['RACK_ENV']}"
    ActiveRecord::Tasks::DatabaseTasks.create config

    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
  end
end
