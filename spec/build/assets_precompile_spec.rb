# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'assets pipeline' do
  let(:gemfile_lock) { Rails.root.join('Gemfile.lock').read }
  let(:esbuild_bundle) { Rails.root.join('app/assets/builds/application.js') }
  let(:manifest) { Rails.root.join('app/assets/config/manifest.js').read }
  let(:js_sources) { Rails.root.join('app/javascript/**/*.js') }

  it 'does not list jquery-rails in Gemfile.lock' do
    expect(gemfile_lock).not_to include('jquery-rails')
  end

  it 'does not list the bootstrap gem in Gemfile.lock' do
    expect(gemfile_lock).not_to match(/^\s+bootstrap\s*\(/m)
  end

  it 'does not register vestigial Sprockets precompile paths or CoffeeScript workarounds' do
    source = Rails.root.join('config/initializers/assets.rb').read

    expect(source).not_to include('config.assets.precompile')
    expect(source).not_to include('coffee_free_transformers')
    expect(source).not_to include('node_modules')
  end

  it 'links builds and images via the Sprockets manifest until Propshaft' do
    expect(manifest).not_to include('link_directory ../javascripts')
    expect(manifest).to include('link_tree ../builds')
    expect(manifest).to include('link_tree ../images')
  end

  it 'does not use Sprockets require directives in app javascript sources' do
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

  it 'compiles vendored Bootstrap SCSS into dartsass builds' do
    css = Rails.root.join('app/assets/builds/application.css').read

    expect(css).to include('--bs-')
    expect(css).to include('.btn')
  end

  it 'vendors Bootstrap SCSS for deploy hosts without node_modules' do
    scss = Rails.root.join('app/assets/stylesheets/vendor/bootstrap/scss/bootstrap.scss')

    expect(scss).to exist
  end

  describe 'assets:precompile task' do
    it 'does not auto-run javascript:build in test (deploy uses committed bundle until Node is on deploy hosts)' do
      Rails.application.load_tasks

      expect(Rake::Task['assets:precompile'].prerequisites).to include('dartsass:build')
      expect(Rake::Task['assets:precompile'].prerequisites).not_to include('javascript:build')
    end
  end
end
