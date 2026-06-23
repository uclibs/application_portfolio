# frozen_string_literal: true

namespace :bootstrap do
  desc 'Copy bootstrap.bundle.min.js from node_modules into Sprockets vendor assets'
  task :vendor do
    source = Rails.root.join('node_modules/bootstrap/dist/js/bootstrap.bundle.min.js')
    destination = Rails.root.join('app/assets/javascripts/vendor/bootstrap.bundle.js')

    abort 'Run yarn install first; bootstrap bundle not found in node_modules' unless source.exist?

    FileUtils.mkdir_p(destination.dirname)
    FileUtils.cp(source, destination)
    puts "Updated #{destination.relative_path_from(Rails.root)}"
  end
end
