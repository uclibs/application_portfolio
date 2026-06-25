# frozen_string_literal: true

require 'pathname'

# Copies Bootstrap assets from node_modules into committed vendor paths for dartsass.
# Deploy hosts do not run yarn until Node is installed on deploy; vendored files must be in git.
# Bootstrap JS is bundled via esbuild (app/javascript/application.js).
# Bootstrap CSS is loaded via meta.load-css in _bootstrap_setup.scss (precompiled dist).
module BootstrapVendor
  module_function

  def vendor!(root = default_root)
    scss = copy_stylesheets!(root)
    css = copy_css!(root)
    { scss: scss, css: css }
  end

  def copy_stylesheets!(root = default_root)
    source = root.join('node_modules/bootstrap/scss')
    destination = root.join('app/assets/stylesheets/vendor/bootstrap/scss')

    abort missing_npm_message unless source.directory?

    FileUtils.rm_rf(destination)
    FileUtils.mkdir_p(destination.parent)
    FileUtils.cp_r(source, destination)
    destination
  end

  def copy_css!(root = default_root)
    source = root.join('node_modules/bootstrap/dist/css/bootstrap.min.css')
    destination = root.join('app/assets/stylesheets/vendor/bootstrap/dist/bootstrap.min.css')

    abort missing_npm_message unless source.file?

    FileUtils.mkdir_p(destination.parent)
    FileUtils.cp(source, destination)
    destination
  end

  def stylesheets_path(root = default_root)
    vendored = root.join('app/assets/stylesheets/vendor/bootstrap/scss')
    npm = root.join('node_modules/bootstrap/scss')

    return vendored if vendored.directory?
    return npm if npm.directory?

    abort 'Bootstrap SCSS not found. Run yarn install and rake bootstrap:vendor.'
  end

  def css_path(root = default_root)
    vendored = root.join('app/assets/stylesheets/vendor/bootstrap/dist/bootstrap.min.css')
    npm = root.join('node_modules/bootstrap/dist/css/bootstrap.min.css')

    return vendored if vendored.file?
    return npm if npm.file?

    abort 'Bootstrap CSS not found. Run yarn install and rake bootstrap:vendor.'
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
