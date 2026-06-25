# frozen_string_literal: true

namespace :bootstrap do
  desc 'Copy Bootstrap CSS from node_modules into committed vendor assets'
  task vendor: :environment do
    destination = BootstrapVendor.vendor!
    puts "Updated #{destination.relative_path_from(Rails.root)}"
  end
end
