# frozen_string_literal: true

# Tests need freshly compiled assets from app/assets/builds/. A leftover
# public/assets manifest from assets:precompile pins stale digests and can
# make stylesheet_link_tag serve outdated CSS from a previous assets:precompile run.
RSpec.configure do |config|
  config.before(:suite) do
    public_assets = Rails.public_path.join('assets')
    FileUtils.rm_rf(public_assets) if public_assets.directory?

    QuietTestBuilds.invoke_dartsass_build!

    # Test uses the committed bundle (SKIP_JS_BUILD); production deploy builds via assets:precompile.
    next if ENV['SKIP_JS_BUILD'] == 'true'

    js_bundle = Rails.root.join('app/assets/builds/application.js')
    js_sources = Rails.root.join('app/javascript/**/*.js')
    next unless EsbuildBundleExpectations.stale_sources?(js_bundle, js_sources)

    QuietTestBuilds.invoke_javascript_build!
  end
end
