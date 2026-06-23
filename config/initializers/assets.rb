# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Compiled CSS/JS from dartsass-rails and esbuild live in app/assets/builds/ (linked in manifest.js).
Rails.application.config.assets.precompile += %w[software_records.css]

# Sprockets 4 always registers a built-in CoffeeScript transformer, which lazily
# requires the `coffee_script` library when resolving any JavaScript asset. Since
# this app no longer depends on CoffeeScript, drop that transformer so precompile
# does not fail loading a gem that is intentionally absent.
Rails.application.config.assets.configure do |env|
  coffee_free_transformers = env.config[:registered_transformers].reject do |transformer|
    transformer.from == 'text/coffeescript' || transformer.to == 'text/coffeescript'
  end
  env.config = env.config.merge(registered_transformers: coffee_free_transformers).freeze
  env.send(:compute_transformers!, coffee_free_transformers)
end
