# frozen_string_literal: true

# Tests need freshly compiled assets from app/assets/builds/. A leftover
# public/assets manifest from assets:precompile pins stale digests and can
# make stylesheet_link_tag serve outdated CSS from a previous assets:precompile run.
RSpec.configure do |config|
  config.before(:suite) do
    public_assets = Rails.public_path.join('assets')
    FileUtils.rm_rf(public_assets) if public_assets.directory?

    Rails.application.load_tasks
    Rake::Task['dartsass:build'].reenable
    Rake::Task['dartsass:build'].invoke

    # Test and production deploy use the committed bundle (SKIP_JS_BUILD in config/application.rb).
    next if ENV['SKIP_JS_BUILD'] == 'true'

    js_bundle = Rails.root.join('app/assets/builds/application.js')
    js_sources = Rails.root.join('app/javascript/**/*.js')
    next unless EsbuildBundleExpectations.stale_sources?(js_bundle, js_sources)

    %w[javascript:prepare_node_path javascript:install javascript:build].each do |name|
      Rake::Task[name].reenable
    end
    Rake::Task['javascript:build'].invoke
  end
end
