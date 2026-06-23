# frozen_string_literal: true

namespace :bootstrap do
  desc 'Copy bootstrap.bundle.min.js from node_modules into Sprockets vendor assets'
  task :vendor do
    destination = BootstrapVendor.copy_bundle!
    puts "Updated #{destination.relative_path_from(Rails.root)}"
  end
end
