# frozen_string_literal: true

# Entry-point SCSS files compiled to app/assets/builds/ by dartsass-rails.
# Bootstrap and gritter still come from gems until npm migration (LIBAPPO1-#16).
# Gritter import rules live in app/assets/stylesheets/_gem_dependencies.scss.
gritter_stylesheets = File.join(Gem.loaded_specs['gritter'].full_gem_path, 'app/assets/stylesheets')
bootstrap_stylesheets = File.join(Gem.loaded_specs['bootstrap'].full_gem_path, 'assets/stylesheets')

Rails.application.config.dartsass.build_options ||= []
Rails.application.config.dartsass.build_options << "--load-path=#{gritter_stylesheets}"
Rails.application.config.dartsass.build_options << "--load-path=#{bootstrap_stylesheets}"

Rails.application.config.dartsass.builds = {
  'application.scss' => 'application.css',
  'software_records.scss' => 'software_records.css'
}
