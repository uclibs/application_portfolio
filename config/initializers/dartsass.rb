# frozen_string_literal: true

# Entry-point SCSS files compiled to app/assets/builds/ by dartsass-rails.
# Bootstrap and gritter still come from gems until #16 (npm Bootstrap migration).
# Gritter import rules live in app/assets/stylesheets/_gem_dependencies.scss.
#
# --quiet-deps and --silence-deprecation=import suppress Dart Sass @import warnings
# (vendor + app SCSS). Remove when SCSS is migrated to @use/@forward (follow-up ticket).
gritter_stylesheets = File.join(Gem.loaded_specs['gritter'].full_gem_path, 'app/assets/stylesheets')
bootstrap_stylesheets = File.join(Gem.loaded_specs['bootstrap'].full_gem_path, 'assets/stylesheets')

Rails.application.config.dartsass.build_options ||= []
Rails.application.config.dartsass.build_options << '--quiet-deps'
Rails.application.config.dartsass.build_options << '--silence-deprecation=import'
Rails.application.config.dartsass.build_options << "--load-path=#{gritter_stylesheets}"
Rails.application.config.dartsass.build_options << "--load-path=#{bootstrap_stylesheets}"

Rails.application.config.dartsass.builds = {
  'application.scss' => 'application.css',
  'software_records.scss' => 'software_records.css'
}
