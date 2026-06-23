# frozen_string_literal: true

require Rails.root.join('lib/bootstrap_vendor')

# Entry-point SCSS files compiled to app/assets/builds/ by dartsass-rails.
# Bootstrap SCSS is vendored from npm (see lib/bootstrap_vendor.rb); deploy hosts
# do not run yarn until #18.
#
# --quiet-deps and --silence-deprecation=import suppress Dart Sass @import warnings
# (vendor + app SCSS). Remove when SCSS is migrated to @use/@forward (follow-up ticket).
bootstrap_scss = BootstrapVendor.stylesheets_path

Rails.application.config.dartsass.build_options ||= []
Rails.application.config.dartsass.build_options << '--quiet-deps'
Rails.application.config.dartsass.build_options << '--silence-deprecation=import'
Rails.application.config.dartsass.build_options << "--load-path=#{bootstrap_scss}"

Rails.application.config.dartsass.builds = {
  'application.scss' => 'application.css',
  'software_records.scss' => 'software_records.css'
}
