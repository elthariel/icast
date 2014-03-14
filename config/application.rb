require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module ICast
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en

    config.generators do |g|
      g.scaffold_controller = :scaffold_controller
    end

    config.autoload_paths += [
      "#{config.root}/app/classes",
      "#{config.root}/app/services",
      "#{config.root}/app/serializers/concerns"
    ]

    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        resource '/1/*', credentials: true, headers: :any, max_age: 1,
          :methods => [:get, :post, :delete, :options, :put, :patch]
      end
    end

    config.cache_store = :redis_store,
      ENV['REDIS_CACHE_URL'] || ENV['REDIS_CACHE_URL'] + "/cache",
      { expires_in: 1.day }
  end
end
