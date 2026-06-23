# frozen_string_literal: true

# Entry-point SCSS files compiled to app/assets/builds/ by dartsass-rails.
# Bootstrap SCSS comes from the npm package (see package.json).
#
# --quiet-deps and --silence-deprecation=import suppress Dart Sass @import warnings
# (vendor + app SCSS). Remove when SCSS is migrated to @use/@forward (follow-up ticket).
bootstrap_scss = Rails.root.join('node_modules/bootstrap/scss')

Rails.application.config.dartsass.build_options ||= []
Rails.application.config.dartsass.build_options << '--quiet-deps'
Rails.application.config.dartsass.build_options << '--silence-deprecation=import'
Rails.application.config.dartsass.build_options << "--load-path=#{bootstrap_scss}"

Rails.application.config.dartsass.builds = {
  'application.scss' => 'application.css',
  'software_records.scss' => 'software_records.css'
}
