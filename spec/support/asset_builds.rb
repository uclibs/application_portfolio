# frozen_string_literal: true

# Tests need freshly compiled assets from app/assets/builds/. A leftover
# public/assets manifest from assets:precompile pins stale digests and can
# make stylesheet_link_tag serve outdated CSS from a previous assets:precompile run.
module TestSuiteAssetBuilds
  module_function

  def record_javascript_digest_if_needed(bundle_path)
    return unless bundle_path.file? && bundle_path.size > 1000
    return if EsbuildBundleExpectations.sources_digest_path.exist?

    EsbuildBundleExpectations.record_sources_digest!
  end
end

RSpec.configure do |config|
  config.before(:suite) do
    public_assets = Rails.public_path.join('assets')
    FileUtils.rm_rf(public_assets) if public_assets.directory?

    QuietTestBuilds.invoke_dartsass_build! if AssetBuildStaleness.dartsass_stale?

    js_bundle = Rails.root.join('app/assets/builds/application.js')
    ci_bundle_ready = ENV['CI'] == 'true' && js_bundle.file? && js_bundle.size > 1000
    needs_javascript_build = AssetBuildStaleness.javascript_stale?(js_bundle)

    QuietTestBuilds.invoke_javascript_build! if needs_javascript_build && !ci_bundle_ready

    TestSuiteAssetBuilds.record_javascript_digest_if_needed(js_bundle)
  end
end
