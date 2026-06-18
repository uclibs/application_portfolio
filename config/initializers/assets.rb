# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path (used by future jsbundling; see LIBAPPO1-#17).
Rails.application.config.assets.paths << Rails.root.join('node_modules')
# Compiled CSS from dartsass-rails lives in app/assets/builds/ (linked in manifest.js).
Rails.application.config.assets.precompile += %w[software_records.css]
# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
Rails.application.config.assets.precompile += %w[navigation.js]
Rails.application.config.assets.precompile += %w[filtermanagement.js]
Rails.application.config.assets.precompile += %w[inputsanitization.js]
Rails.application.config.assets.precompile += %w[multivalueinputs.js]

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
