require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CtFlights
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.autoload_paths += %W(#{config.root}/lib)

    config.autoload_paths += Dir[File.join("#{Rails.root.to_s}", 'app', 'workers', "Shared")]
    config.autoload_paths += Dir[File.join("#{Rails.root.to_s}", 'app', 'workers', "**","*")]
    config.autoload_paths += Dir[File.join("#{Rails.root.to_s}", 'lib',"*")]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
