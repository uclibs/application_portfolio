# frozen_string_literal: true

require 'digest'
require 'fileutils'

# Copies Bootstrap CSS from node_modules into committed vendor paths for dartsass.
# Deploy hosts do not run yarn until Node is installed on deploy; vendored files must be in git.
# Bootstrap JS is bundled via esbuild (app/javascript/application.js).
# Bootstrap CSS is loaded via meta.load-css in _bootstrap_setup.scss (precompiled dist).
module BootstrapVendor
  module_function

  VENDOR_CSS_RELATIVE = 'app/assets/stylesheets/vendor/bootstrap/dist/bootstrap.min.css'
  NPM_CSS_RELATIVE = 'node_modules/bootstrap/dist/css/bootstrap.min.css'
  # Relative to app/assets/stylesheets/ for meta.load-css in _bootstrap_setup.scss.
  SASS_LOAD_CSS_PATH = 'vendor/bootstrap/dist/bootstrap.min.css'

  def vendor!(root = default_root)
    source = npm_css_path(root)
    destination = vendor_css_path(root)

    abort missing_npm_message unless source.file?

    FileUtils.mkdir_p(destination.parent)
    FileUtils.cp(source, destination)
    destination
  end

  def stale_vendored_css?(root = default_root)
    source = npm_css_path(root)
    destination = vendor_css_path(root)

    return false unless source.file?
    return true unless destination.file?

    Digest::SHA256.file(source).hexdigest != Digest::SHA256.file(destination).hexdigest
  end

  def vendor_css_path(root = default_root)
    root.join(VENDOR_CSS_RELATIVE)
  end

  def npm_css_path(root = default_root)
    root.join(NPM_CSS_RELATIVE)
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
