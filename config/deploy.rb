require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'
require "mina_sidekiq/tasks"

set :domain, 'deploy@straight'
set :port, 22
set :repository, '/var/repos/gear-admin.git'
set :forward_agent, true
set :rvm_path, '/usr/local/rvm/scripts/rvm'

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, %w(config/database.yml config/environment.yml config/admin_emails.txt
  config/secrets.yml log config/straight vendor/gems config/sidekiq.yml)

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  stage_param = ENV['to']
  if stage_param == 'production'
    set :stage, 'production'
    invoke :'rvm:use[ruby-ruby-2.2-head@production]'
  else
    set :stage, 'staging'
    invoke :'rvm:use[ruby-ruby-2.2-head@staging]'
  end

  set :branch, stage
  set :rails_env, stage
  set :deploy_to, "/var/www/gear-admin/#{stage}"
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/log"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/config"]

  queue! %[touch "#{deploy_to}/#{shared_path}/config/database.yml"]
  queue  %[echo "-----> Be sure to edit '#{deploy_to}/#{shared_path}/config/database.yml'."]
  
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/pids"]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  to :before_hook do
    # Put things to run locally before ssh
  end
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'sidekiq:quiet'
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'link_straight_gems_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    to :launch do
      queue "mkdir -p #{deploy_to}/#{current_path}/tmp/"
      queue "touch #{deploy_to}/#{current_path}/tmp/restart.txt"
      invoke :'sidekiq:restart'
    end
  end
end

task :link_straight_gems_paths => :environment do
  in_directory "#{deploy_to}/shared/vendor/gems" do
    queue "rm -f straight*"
    queue "ln -s $(gem path straight) ./straight-engine"
    queue "ln -s $(gem path straight-server) ./straight-server"
  end
end

task :restart_rails do
  queue "mkdir -p #{deploy_to}/#{current_path}/tmp/"
  queue "touch #{deploy_to}/#{current_path}/tmp/restart.txt"
  invoke :'sidekiq:restart'
end
