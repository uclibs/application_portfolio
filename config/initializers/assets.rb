# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Bust digests when you need to expire all cached assets.
Rails.application.config.assets.version = '1.0'

# Source SCSS is compiled to app/assets/builds/ by dartsass-rails; do not serve raw stylesheets.
# Legacy app/assets/javascripts is unused (esbuild bundle lives in app/assets/builds/).
Rails.application.config.assets.excluded_paths = [
  Rails.root.join('app/assets/stylesheets'),
  Rails.root.join('app/assets/javascripts'),
  Rails.root.join('app/assets/config')
]
