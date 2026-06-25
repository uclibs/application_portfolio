# frozen_string_literal: true

# Entry-point SCSS files compiled to app/assets/builds/ by dartsass-rails.
# Bootstrap SCSS is imported from app/assets/stylesheets/vendor/bootstrap/scss/
# (vendored from npm; see lib/bootstrap_vendor.rb and README).
#
# Bootstrap 5.3 SCSS still uses @import and legacy Sass APIs that Dart Sass deprecates.
# --quiet-deps and --silence-deprecation keep build/test output readable until Bootstrap
# migrates to @use/@forward and modern color/builtin APIs (or we change CSS strategy).
Rails.application.config.dartsass.build_options ||= []
Rails.application.config.dartsass.build_options |= %w[
  --quiet-deps
  --silence-deprecation=import
  --silence-deprecation=color-functions
  --silence-deprecation=if-function
  --silence-deprecation=global-builtin
]

Rails.application.config.dartsass.builds = {
  'application.scss' => 'application.css',
  'software_records.scss' => 'software_records.css'
}
