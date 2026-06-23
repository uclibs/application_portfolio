# frozen_string_literal: true

require 'pathname'

# Copies the Bootstrap bundle from node_modules into Sprockets vendor assets.
module BootstrapVendor
  module_function

  def copy_bundle!(root = default_root)
    source = root.join('node_modules/bootstrap/dist/js/bootstrap.bundle.min.js')
    destination = root.join('app/assets/javascripts/vendor/bootstrap.bundle.js')

    abort 'Run yarn install first; bootstrap bundle not found in node_modules' unless source.exist?

    FileUtils.mkdir_p(destination.dirname)
    FileUtils.cp(source, destination)
    destination
  end

  def default_root
    if defined?(Rails) && Rails.application&.initialized?
      Rails.root
    else
      Pathname.new(File.expand_path('..', __dir__))
    end
  end
end
