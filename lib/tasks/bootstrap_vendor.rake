# frozen_string_literal: true

namespace :bootstrap do
  desc 'Copy Bootstrap SCSS and CSS from node_modules into committed vendor assets'
  task vendor: :environment do
    destinations = BootstrapVendor.vendor!
    puts "Updated #{destinations[:scss].relative_path_from(Rails.root)}"
    puts "Updated #{destinations[:css].relative_path_from(Rails.root)}"
  end
end
