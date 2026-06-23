# frozen_string_literal: true

require 'pathname'

# Copies Bootstrap SCSS from node_modules into a committed vendor path for dartsass.
# Deploy hosts do not run yarn (#18); vendored files must be in git.
# Bootstrap JS is bundled via esbuild (app/javascript/application.js).
module BootstrapVendor
  module_function

  def vendor!(root = default_root)
    scss = copy_stylesheets!(root)
    { scss: scss }
  end

  def copy_stylesheets!(root = default_root)
    source = root.join('node_modules/bootstrap/scss')
    destination = root.join('app/assets/stylesheets/vendor/bootstrap/scss')

    abort missing_npm_message unless source.directory?

    FileUtils.rm_rf(destination.parent)
    FileUtils.mkdir_p(destination.parent)
    FileUtils.cp_r(source, destination)
    destination
  end

  def stylesheets_path(root = default_root)
    vendored = root.join('app/assets/stylesheets/vendor/bootstrap/scss')
    npm = root.join('node_modules/bootstrap/scss')

    return vendored if vendored.directory?
    return npm if npm.directory?

    abort 'Bootstrap SCSS not found. Run yarn install and rake bootstrap:vendor.'
  end

  def default_root
    if defined?(Rails) && Rails.application&.initialized?
      Rails.root
    else
      Pathname.new(File.expand_path('..', __dir__))
    end
  end

  def missing_npm_message
    'Run yarn install first; bootstrap package not found in node_modules'
  end
end
