# frozen_string_literal: true

namespace :bootstrap do
  desc 'Copy Bootstrap JS and SCSS from node_modules into committed vendor assets'
  task vendor: :environment do
    js_dest = BootstrapVendor.copy_bundle!
    scss_dest = BootstrapVendor.copy_stylesheets!
    puts "Updated #{js_dest.relative_path_from(Rails.root)}"
    puts "Updated #{scss_dest.relative_path_from(Rails.root)}"
  end
end
