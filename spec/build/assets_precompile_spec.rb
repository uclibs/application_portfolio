# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'assets pipeline' do
  let(:gemfile_lock) { Rails.root.join('Gemfile.lock').read }
  let(:esbuild_bundle) { Rails.root.join('app/assets/builds/application.js') }
  let(:manifest) { Rails.root.join('app/assets/config/manifest.js').read }

  it 'does not list jquery-rails in Gemfile.lock' do
    expect(gemfile_lock).not_to include('jquery-rails')
  end

  it 'does not list the bootstrap gem in Gemfile.lock' do
    expect(gemfile_lock).not_to match(/^\s+bootstrap\s*\(/m)
  end

  it 'does not link the legacy Sprockets javascripts directory in the asset manifest' do
    expect(manifest).not_to include('link_directory ../javascripts')
    expect(manifest).to include('link_tree ../builds')
  end

  it 'does not use Sprockets require directives in app javascript sources' do
    Dir.glob(Rails.root.join('app/javascript/**/*.js')).each do |path|
      expect(File.read(path)).not_to match(%r{//= require})
    end
  end

  it 'ships the esbuild application bundle with Turbo, Chartkick, and app scripts' do
    expect(esbuild_bundle).to exist

    bundle = esbuild_bundle.read
    expect(bundle).to match(/turbo/i)
    expect(bundle).to match(/chartkick|Chartkick/i)
    expect(bundle).to include('js-add-multivalue')
    expect(bundle).to match(/Dropdown|data-bs-toggle/i)
    expect(bundle).not_to include('@rails/ujs')
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
    it 'does not auto-run javascript:build in test (deploy uses committed bundle until #18)' do
      Rails.application.load_tasks

      expect(Rake::Task['assets:precompile'].prerequisites).to include('dartsass:build')
      expect(Rake::Task['assets:precompile'].prerequisites).not_to include('javascript:build')
    end
  end
end
