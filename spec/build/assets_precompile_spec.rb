# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'assets pipeline' do
  let(:gemfile_lock) { Rails.root.join('Gemfile.lock').read }
  let(:esbuild_bundle) { Rails.root.join('app/assets/builds/application.js') }
  let(:js_sources) { Rails.root.join('app/javascript/**/*.js') }

  it 'uses propshaft instead of sprockets' do
    expect(gemfile_lock).to include('propshaft')
    expect(gemfile_lock).not_to include('sprockets-rails')
    expect(gemfile_lock).not_to match(/^\s+sprockets\s*\(/m)
  end

  it 'does not list jquery-rails in Gemfile.lock' do
    expect(gemfile_lock).not_to include('jquery-rails')
  end

  it 'does not list the bootstrap gem in Gemfile.lock' do
    expect(gemfile_lock).not_to match(/^\s+bootstrap\s*\(/m)
  end

  it 'sets the Propshaft assets version for cache busting' do
    expect(Rails.application.config.assets.version).to eq('1.0')
  end

  it 'excludes source stylesheets from Propshaft load paths' do
    paths = Rails.application.config.assets.paths.map(&:to_s)
    excluded = Rails.application.config.assets.excluded_paths.map(&:to_s)

    expect(excluded).to eq([Rails.root.join('app/assets/stylesheets').to_s])
    expect(paths).to include(Rails.root.join('app/assets/builds').to_s)
    expect(paths).to include(Rails.root.join('app/assets/images').to_s)
    expect(paths).not_to include(Rails.root.join('app/assets/stylesheets').to_s)
    expect(paths).not_to include(a_string_matching(%r{/node_modules\z}))
  end

  it 'does not ship manifest.js' do
    expect(Rails.root.join('app/assets/config/manifest.js')).not_to exist
  end

  it 'does not use asset pipeline require directives in app javascript sources' do
    Dir.glob(js_sources.to_s).each do |path|
      expect(File.read(path)).not_to match(%r{//= require})
    end
  end

  it 'locks @popperjs/core in package.json and yarn.lock for reproducible esbuild installs' do
    package_json = JSON.parse(Rails.root.join('package.json').read)
    yarn_lock = Rails.root.join('yarn.lock').read

    expect(package_json.fetch('dependencies')).to include('@popperjs/core')
    expect(yarn_lock).to include('@popperjs/core@')
  end

  it 'pins Yarn 4 via Corepack with node-modules linking and without weakened security defaults' do
    package_json = JSON.parse(Rails.root.join('package.json').read)
    yarnrc = Rails.root.join('.yarnrc.yml').read

    expect(package_json['packageManager']).to start_with('yarn@4.')
    expect(yarnrc).to include('nodeLinker: node-modules')
    expect(yarnrc).to include('enableScripts: true')
    expect(yarnrc).not_to include('npmMinimalAgeGate')
    expect(yarnrc).not_to include('approvedGitRepositories')
  end

  it 'ships the esbuild application bundle with Turbo, Chartkick, and app scripts' do
    expect(esbuild_bundle).to exist

    expect_core_bundle_content!(esbuild_bundle.read)
  end

  it 'ships an esbuild bundle that is at least as new as app/javascript sources' do
    expect(esbuild_bundle).to exist
    expect(EsbuildBundleExpectations.sources_digest_path).to exist

    stale_message = 'Run yarn install && yarn build and commit app/assets/builds/application.js ' \
                    'and application.js.sources.sha256'
    expect(EsbuildBundleExpectations.stale_sources?(esbuild_bundle, js_sources)).to be(false), stale_message
  end

  it 'compiles vendored Bootstrap CSS into dartsass builds' do
    css = Rails.root.join('app/assets/builds/application.css').read

    expect(css).to include('--bs-')
    expect(css).to include('.btn')
  end

  it 'vendors Bootstrap CSS for deploy hosts without node_modules' do
    bootstrap_css = Rails.root.join('app/assets/stylesheets/vendor/bootstrap/dist/bootstrap.min.css')
    bootstrap_scss = Rails.root.join('app/assets/stylesheets/vendor/bootstrap/scss')

    expect(bootstrap_css).to exist
    expect(bootstrap_scss).not_to exist
  end

  it 'uses @use in app-owned SCSS and does not silence Dart Sass deprecations' do
    stylesheets = Rails.root.join('app/assets/stylesheets')
    app_scss = Dir.glob(stylesheets.join('**/*.{scss,sass}')).reject do |path|
      path.include?('/vendor/')
    end

    expect(app_scss).not_to be_empty
    app_scss.each do |path|
      expect(File.read(path)).not_to match(/@import\b/), "#{path} still uses @import"
    end

    %w[application.scss software_records.scss _dashboard_core.scss].each do |filename|
      expect(File.read(stylesheets.join(filename))).to match(/@use\b/), "#{filename} should use @use"
    end

    bootstrap_setup = Rails.root.join('app/assets/stylesheets/_bootstrap_setup.scss').read
    expect(bootstrap_setup).to include('meta.load-css')

    dartsass_rb = Rails.root.join('config/initializers/dartsass.rb').read
    expect(dartsass_rb).not_to include('--quiet-deps')
    expect(dartsass_rb).not_to include('--silence-deprecation')
  end

  describe 'assets:precompile task' do
    let(:public_assets) { Rails.public_path.join('assets') }

    after do
      FileUtils.rm_rf(public_assets)
    end

    it 'sets SKIP_JS_BUILD in test so CI uses the committed bundle' do
      expect(ENV['SKIP_JS_BUILD']).to eq('true')
    end

    it 'skips javascript:build in test (deploy builds on the server)' do
      Rails.application.load_tasks

      install_prereqs = Rake::Task['javascript:install'].prerequisites
      expect(install_prereqs).to include('javascript:prepare_node_path')

      expect(Rake::Task['assets:precompile'].prerequisites).to include('dartsass:build')
      expect(Rake::Task['assets:precompile'].prerequisites).not_to include('javascript:build')
    end

    it 'fingerprints dartsass and esbuild outputs and writes .manifest.json' do
      QuietTestBuilds.precompile_assets!

      expect(public_assets.join('.manifest.json')).to exist
      expect(CompiledAssetExpectations.fingerprinted_asset?(public_assets, 'application', '.js')).to be(true)
      expect(CompiledAssetExpectations.fingerprinted_asset?(public_assets, 'application', '.css')).to be(true)
      expect(CompiledAssetExpectations.fingerprinted_asset?(public_assets, 'software_records', '.css')).to be(true)
      expect(Dir.glob(public_assets.join('**/*.scss'))).to be_empty
    end

    it 'maps logical asset names to digest filenames in .manifest.json' do
      QuietTestBuilds.precompile_assets!

      manifest = JSON.parse(public_assets.join('.manifest.json').read)

      expect(manifest.dig('application.js', 'digested_path')).to match(/\Aapplication-[a-f0-9]+\.js\z/)
      expect(manifest.dig('application.css', 'digested_path')).to match(/\Aapplication-[a-f0-9]+\.css\z/)
    end

    it 'configures far-future cache-control for production deploys (QA and production)' do
      production_rb = Rails.root.join('config/environments/production.rb').read

      expect(production_rb).to include("config.public_file_server.headers = { 'cache-control' => \"public, max-age=\#{1.year.to_i}\" }")
      expect(Rails.root.join('config/deploy/qa.rb').read).to include('set :rails_env, :production')
      expect(Rails.root.join('config/deploy/production.rb').read).to include('set :rails_env, :production')
    end
  end
end
