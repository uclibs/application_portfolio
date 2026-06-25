# frozen_string_literal: true

# Entry-point SCSS files compiled to app/assets/builds/ by dartsass-rails.
# App styles use @use/@forward. Bootstrap CSS is vendored as precompiled
# bootstrap.min.css (see lib/bootstrap_vendor.rb) and loaded via meta.load-css.
Rails.application.config.dartsass.build_options ||= []

Rails.application.config.dartsass.builds = {
  'application.scss' => 'application.css',
  'software_records.scss' => 'software_records.css'
}
