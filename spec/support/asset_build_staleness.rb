# frozen_string_literal: true

module AssetBuildStaleness
  module_function

  def javascript_stale?(bundle_path = Rails.root.join('app/assets/builds/application.js'),
                        source_glob = Rails.root.join('app/javascript/**/*.js'))
    EsbuildBundleExpectations.stale_sources?(bundle_path, source_glob)
  end

  def dartsass_stale?(builds_dir = Rails.root.join('app/assets/builds'))
    css_files = Dir.glob(builds_dir.join('*.css').to_s)
    return true if css_files.empty?

    stylesheet_inputs = Dir.glob(Rails.root.join('app/assets/stylesheets/**/*.{scss,sass}').to_s)
    other_inputs = [
      BootstrapVendor.vendor_css_path,
      Rails.root.join('config/initializers/dartsass.rb')
    ]
    inputs = (stylesheet_inputs + other_inputs).select { |path| File.file?(path) }
    return true if inputs.empty?

    latest_input_mtime = inputs.map { |path| File.mtime(path) }.max
    oldest_css_mtime = css_files.map { |path| File.mtime(path) }.min
    latest_input_mtime > oldest_css_mtime
  end
end
