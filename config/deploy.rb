require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'
require 'mina_sidekiq/tasks'
require "yaml"
require "slack-notifier"
# /etc/sudoers should contain:
# deploy ALL=(root) NOPASSWD: /sbin/restart, /sbin/start

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
    set :git_remote, 'production-server'
    set :rails_env, 'production'
    set :domain, 'deploy@gear.mycelium.com'
    set :branch, 'production'
    invoke :'rvm:use[ruby-ruby-2.2-head@production]'
  elsif stage_param == 'staging'
    set :stage, 'staging'
    set :git_remote, 'staging-server'
    set :rails_env, 'staging'
    set :domain, 'deploy@staging.gearpayments.com'
    set :branch, 'staging'
    invoke :'rvm:use[ruby-ruby-2.2@staging]'
  else
    set :rails_env, 'staging'
    set :git_remote, 'staging-server'
    set :stage, 'staging-b'
    set :domain, 'deploy@staging.gearpayments.com'
    set :branch, (ENV['branch'] || 'master')
    invoke :'rvm:use[ruby-ruby-2.2@staging-b]'
  end

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
    # So we don't have to do it manually
    queue "git push #{git_remote} #{branch}"
  end
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'sidekiq:quiet' 
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'link_straight_gems_paths'
    invoke :'copy_dotenv' unless stage == "production"
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'
    invoke :'deploy:cleanup'
    invoke :'notify_slack'

    to :launch do
      queue "mkdir -p #{deploy_to}/#{current_path}/tmp/"
      queue "touch #{deploy_to}/#{current_path}/tmp/restart.txt"
      invoke :'restart_sidekiq'
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

task :copy_dotenv => :environment do
  queue "cp #{deploy_to}/#{shared_path}/.env* ."
end

task :restart_rails => :environment do
  queue "mkdir -p #{deploy_to}/#{current_path}/tmp/"
  queue "touch #{deploy_to}/#{current_path}/tmp/restart.txt"
  invoke :'restart_sidekiq'
end

task :notify_slack => :environment do
  notifier = Slack::Notifier.new(
    'https://hooks.slack.com/services/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',
    channel: '#general',
    username: "#{stage} deployment"
  )
  notifier.ping "*Admin App* was just deployed to *#{stage}* from branch *#{branch}*", icon_url: "http://staging.gearpayments.com/images/deployment_#{stage}.png"
end

# Because default mina-sidekiq tasks don't work for some reason
task :restart_sidekiq => :environment do
  invoke :'sidekiq:restart'
  queue "sleep 1" # Not enough time for daemon to be spawned, we need this!
end
