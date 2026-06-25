# frozen_string_literal: true

# Tests need freshly compiled assets from app/assets/builds/. A leftover
# public/assets manifest from assets:precompile pins stale digests and can
# make stylesheet_link_tag serve outdated CSS from a previous assets:precompile run.
RSpec.configure do |config|
  config.before(:suite) do
    public_assets = Rails.public_path.join('assets')
    FileUtils.rm_rf(public_assets) if public_assets.directory?

    QuietTestBuilds.invoke_dartsass_build!

    js_bundle = Rails.root.join('app/assets/builds/application.js')
    ci_bundle_ready = ENV['CI'] == 'true' && js_bundle.file? && js_bundle.size > 1000
    QuietTestBuilds.invoke_javascript_build! unless ci_bundle_ready
  end
end
