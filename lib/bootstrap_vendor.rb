# frozen_string_literal: true

require 'pathname'

# Copies Bootstrap CSS from node_modules into committed vendor paths for dartsass.
# Deploy hosts do not run yarn until Node is installed on deploy; vendored files must be in git.
# Bootstrap JS is bundled via esbuild (app/javascript/application.js).
# Bootstrap CSS is loaded via meta.load-css in _bootstrap_setup.scss (precompiled dist).
module BootstrapVendor
  module_function

  def vendor!(root = default_root)
    copy_css!(root)
  end

  def copy_css!(root = default_root)
    source = root.join('node_modules/bootstrap/dist/css/bootstrap.min.css')
    destination = root.join('app/assets/stylesheets/vendor/bootstrap/dist/bootstrap.min.css')

    abort missing_npm_message unless source.file?

    FileUtils.mkdir_p(destination.parent)
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

  def missing_npm_message
    'Run yarn install first; bootstrap package not found in node_modules'
  end
end
