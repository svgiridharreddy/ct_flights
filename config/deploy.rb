# config valid only for current version of Capistrano
lock "3.10.1"

set :application, "ct_flights"
set :repo_url, "git@github.com:svgiridharreddy/ct_flights.git"
set :deploy_to, '/var/www/flights-dynamic'
set :scm, :git
set :branch, 'testing'
set :keep_releases, 5
set :format, :pretty
set :log_level, :debug
set :pty, true
# set :rvm_map_bins, %w{rake gem bundle ruby rails}
set :linked_dirs, %w{pids log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :stages, %w(staging production development)
set :default_stage, "development"
set :ssh_options, {:forward_agent => true}
set :user, "ubuntu"

# Force rake through bundle exec
SSHKit.config.command_map[:rake] = "bundle exec rake"

# Force rails through bundle exec
SSHKit.config.command_map[:rails] = "bundle exec rails"

set :migration_role, 'app' # Defaults to 'db'
set :assets_roles, [:app] # Defaults to [:web]
set :linked_files, %w(config/database.yml)

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # execute :rake,"db:create"
      # execute :rake,"db:migrate"
      # execute "chmod 777 -R #{release_path}/tmp"
      execute "sudo service apache2 restart"
      # execute "sudo touch #{File.join(current_path,'tmp','restart.txt')}"
    end
  end
  
  after :finishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
  

  # after :bundle, 'deploy:after_bundle'
end 
# set :config_files,%w(
# config/database.example.yml
# 	)

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5
