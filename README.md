Gear Admin rails app
====================
A Ruby On Rails app serving as a frontend for merchants of Mycelium Gear.

Important notes about the design and how it works with straight-server:
* Uses `straight-server` and `straight` gems to connect to the Straight payment processor DB (adapter: Sequel)
* Most interaction with the Straight server DB happens in `Gateway` model callbacks
* Gateway model itself is mirroring the Straight server [Sequel](http://sequel.jeremyevans.net/) model, but also has some additional fields
* This app doesn't require you to have straight-server launched, but it is implicit that you have a straight-server config file and also the Database which straight-server uses - which means you should install straight-server on your machine and launch it at least once.

Dependencies
------------
* Postgresql server
* Redis server
* straight-server (doesn't need to be launched at the time of running the Rails app, but you should've launched it at least once)
* Ruby 2.2

Installing locally with Docker
------------------------------
Development environment is managed by [Docker Compose](https://larry-price.com/blog/2015/02/26/a-quick-guide-to-using-docker-compose-previously-fig).

All required dependencies are installed using following commands. It takes some time and bandwidth.

    docker pull postgres:9.4.1
    docker pull redis:3.0.1
    docker-compose build
    docker-compose up

Then containers can be stopped/started with:

    docker-compose stop
    docker-compose start

Consider adding following lines to your `~/.ssh/config`

    Host 127.0.0.1
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null

And the following to your `/etc/hosts`:

    127.0.0.1 admin.gear.loc

`web` container can be easily accessed via ssh:

    bin/ssh_web

Make sure you created the following files:

    * config/database.yml (has a .sample file)
    * config/environment.yml (has a .sample file)
    * config/secrets.yml (has a .sample file)
    * config/sidekiq.yml (has a .sample file)
    * config/admin_emails.txt (leave it empty)
    * .env.development.local  (has a .sample file)
    * .env.test.local  (has a .sample file)

Since the Rails app uses `straight-server` gem it actually requires its config files too. You need two versions of those config files:
for the development and test environments. Here's the best approach:

    cd .. # into something like ~/Projects
    git clone https://github.com/snitko/straight.git
    git clone https://github.com/snitko/straight-server.git
    git clone https://github.com/MyceliumGear/address-providers.git
    git clone https://github.com/MyceliumGear/straight-payment-ui.git
    cd straight-payment-ui
    git submodule init
    git submodule update
    cd ../admin-app
    mkdir config/straight
    cd config/straight
    ln -fs /home/app/.straight development
    ln -fs ../../vendor/gems/straight-server/spec/.straight test

Then inside `web` container:

    cd /gear-admin
    bin/setup

It will install gems and then fail. Now run:

    cd /gear-admin/vendor/gems/straight-server
    bundle exec bin/straight-server

It will generate sample config end exit. Edit it:

    vim /home/app/.straight/config.yml

    * set `gateway_source: db`.
    * uncomment the Redis-related section and set `host: redis`, `port: 6379`, `db: 1`

Also, edit `vendor/gems/straight-server/spec/.straight/config.yml`:

    cd vendor/gems/straight-server
    vim spec/.straight/config.yml

    * in the Redis-related section set `host: redis`, `db: 2`

Now re-run `bin/setup` inside `web` container, it should succeed.

After doing all that you should be able to successfully run the unit tests with `bin/rspec spec`.

To make the app available on you host machine on [admin.gear.loc](http://admin.gear.loc/) run:

    sudo service nginx restart
    bin/rails s

### `straight-server` addons installation:

    cd ~/.straight
    ln -s /gear-admin/vendor/gems/straight-payment-ui/
    ln -s /gear-admin/vendor/gems/address-providers/
    vim addons.yml

Paste:

    payment_ui:
      path: straight-payment-ui/lib/payment_ui
      module: PaymentUI
    cashila:
      path: address-providers/cashila/lib/addon
      module: Cashila

Save.

    vim AddonsGemfile

Paste:

    eval_gemfile '/home/app/.straight/straight-payment-ui/Gemfile'
    eval_gemfile '/home/app/.straight/address-providers/cashila/Gemfile'

Save.

    cd /gear-admin/vendor/gems/straight-server
    bundle --path .bundle/bundle
    ~/straight-server


Installing locally manually
---------------------------

1. After cloning the repo, make sure you create the following files in `/config`:
    
    * database.yml (has a .sample file)
    * environment.yml (has a .sample file)
    * secrets.yml (has a sample file)

2. Create `gear_admin_dev` and `gear_admin_test` databases in Postgres, edit database.yml accordingly.

3. Since the Rails app uses `straight-server` gem it actually requires its config files too. You need two versions of those config files:
for the development and test environments. Here's the best approach:

    * Create a `config/straight` directory
    * in that directory create a symlink called `development` which points to `~/.straight` dir,
    which is a standard directory for the `straight-server` config file.
    * create a symlink called `test` which points to the spec config in your local repo of the
    `straight-server` (for example, on my machine it's `~/Work/straight/server/spec/.straight/`)

4. straight-server and straight gems are installed from the local path (see the gem files). This
is needed so we can control each environment and what version/build of the gem is being used. In development,
you can simply link to the directories where your `straight` and `straight-server` repos are placed.
For example, assuming you're in the admin-app directory:

    ln -s ~/Work/straight-server vendor/gems/straight-server
    ln -s ~/Work/straight        vendor/gems/straight-engine
    
5. Create admin_emails.txt file (to be removed soon), you can leave it empty.

6. Edit your `~/.straight/config.yml` file, uncomment the Redis-related section and also change `gateway_source` to `db`.

7. Run `bundle install`, then `rake db:migrate`

After doing all that you should be able to successfully run the unit tests
with `rspec spec`.

Using nginx locally
-------------------
It is recommended to run the app on the localhost using nginx proxying and locally available domain names.
Without it, certain parts of the app may not work properly (like displaying a widget, for example).

Here's what you should do:

1. Install nginx
2. Add a file called `/etc/nginx/sites-enabled/gear-admin` and put the following content in there:

        server { 
          listen 80; 
          server_name admin.gear.loc;

          location / { 
            proxy_pass http://localhost:3000; 
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $remote_addr;
          }

        }
        
3. Add the following to your `/etc/hosts`:

        127.0.0.1 admin.gear.loc
        
4. Restart nginx

Infrastructure provisioning
---------------------------

1. Install Ansible:

        sudo apt-add-repository ppa:rquillo/ansible
        sudo apt-get update
        sudo apt-get install ansible

2. Create provisioning key, `ssh-add` it locally and add its public part to the `~/.ssh/authorized_keys` on server.

4. Deploy all the things:

        bin/decrypt_secrets
        ansible-playbook -i config/ansible/inventories/stage config/ansible/site.yml
