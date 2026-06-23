# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Change the load order. dotenv environment gets fired first.
Dotenv::Rails.load

# jsbundling-rails reads SKIP_JS_BUILD when rake tasks load (before initializers).
# Deploy hosts lack Node 24 until Node is installed on deploy; committed app/assets/builds/application.js is used instead.
ENV['SKIP_JS_BUILD'] = 'true' if %w[production test].include?(ENV['RAILS_ENV'])

module ApplicationPortfolio
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Never expose raw validation messages from SSO provisioning unless an environment opts in.
    config.x.auth.expose_shibboleth_validation_errors = false

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
