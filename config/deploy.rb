lock '3.3.5'

require "bundler/capistrano"
require "rvm/capistrano"
require 'capistrano_colors'
load    'deploy/assets'

set :rvm_ruby_string, 'ruby-2.2.0p1'
set :rvm_type, :system
set :rvm_path, "/usr/local/rvm"
set :application, "gear-admin"
set :repository,  "/var/repos/gear-admin.git"
set :local_repository,  "ssh://deploy@straight/var/repos/gear-admin.git"
set :branch, "master"
set :user,   "deploy"
set :deploy_via, :remote_cache
set :git_enable_submodules, 1
set :keep_releases, 3
set :scm, :git
set :use_sudo, false

set :normalize_asset_timestamps, false

task :production do
  set :deploy_to, "/var/www/#{application}/production"
  set :rails_env, "migration"
  set :branch, "production"
end

task :staging do
  set :deploy_to, "/var/www/#{application}/staging"
  set :rails_env, "migration"
  set :branch, "staging"
end

production

role :web, "straight"                   # Your HTTP server, Apache/etc
role :app, "straight"                   # This may be the same as your `Web` server
role :db,  "straight", :primary => true # This is where Rails migrations will run

#ssh_options[:port] = 7834
#set :port, 7834

namespace :deploy do

  namespace :custom_symlinks do

    task :custom_configs do
      run "ln -nsf #{shared_path}/config/database.yml #{current_release}/config/" 
      run "ln -nsf #{shared_path}/config/secrets.yml #{current_release}/config/" 
      run "ln -nsf #{shared_path}/config/environment.yml #{current_release}/config/" 
      run "ln -nsf #{shared_path}/config/admin_emails.txt #{current_release}/config/" 
    end

    task :custom_symlinks do
      #run "ln -s #{shared_path}/public/uploads #{current_release}/public/uploads"
    end

    task :default do
      custom_symlinks
      custom_configs
    end

  end


  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

end

namespace :migrate do

  task :default do
    run "cd #{current_release} && bundle exec rake db:migrate" 
  end

end

before "deploy:assets:precompile", "deploy:custom_symlinks"
after  "deploy:update", "deploy:cleanup"
