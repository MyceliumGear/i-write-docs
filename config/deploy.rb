set :application, "gear-admin"
set :default_env, { rvm_bin_path: '~/.rvm/bin' }

set :scm, :git
set :repo_url,  "deploy@gearpayments.com:/var/repos/gear-admin.git"
set :log_level, :info

set :linked_files, %w{config/database.yml config/environment.yml config/admin_emails.txt}
set :linked_dirs, %w{bin log tmp vendor/bundle public/system config/straight}

SSHKit.config.command_map[:rake]  = "bundle exec rake" #8
SSHKit.config.command_map[:rails] = "bundle exec rails"

set :keep_releases, 20

namespace :deploy do

  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join("tmp/restart.txt")
    end
  end

  after :finishing, "deploy:cleanup"

end
