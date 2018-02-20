set :branch, 'testing'
set :stage, :development
# Setting RAILS_ENV environment variable on server
set :rails_env, :development
set :deploy_to, '/var/www/flights-dynamic'
set :normalize_asset_timestamps, %{public/images public/javascripts public/stylesheets}
 
role :app, %w{ubuntu@52.77.224.118}

set :ssh_options, {
   forward_agent: true,
   user: "ubuntu",
   :keepalive => true,
   :keepalive_interval => 3000
}
set :user, "ubuntu"
# Force rake through bundle exec
SSHKit.config.command_map[:rake] = "bundle exec rake"

# Force rails through bundle exec
SSHKit.config.command_map[:rails] = "bundle exec rails"