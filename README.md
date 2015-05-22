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
* straight-server (doesn't need to be launched)
* Ruby 2.2

Installing locally
------------------

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
    
4. Create admin_emails.txt file (to be removed soon), you can leave it empty.

5. Edit your `~/.straight/config.yml` file, uncomment the Redis-related section and also change `gateway_source` to `db`.

6. Run `bundle install`, then 'rake db:migrate'

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
        
4. Restart nginx with `sudo service nginx restart`
