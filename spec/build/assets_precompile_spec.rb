# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'assets pipeline' do
  let(:sprockets_manifest) { Rails.root.join('app/assets/javascripts/application.js').read }
  let(:gemfile_lock) { Rails.root.join('Gemfile.lock').read }

  it 'does not require jquery in the Sprockets manifest' do
    expect(sprockets_manifest).not_to match(/require jquery/i)
  end

  it 'does not list jquery-rails in Gemfile.lock' do
    expect(gemfile_lock).not_to include('jquery-rails')
  end

  it 'does not list the bootstrap gem in Gemfile.lock' do
    expect(gemfile_lock).not_to match(/^\s+bootstrap\s*\(/m)
  end

  it 'requires the Bootstrap bundle with Popper for Sprockets' do
    expect(sprockets_manifest).to include('require vendor/bootstrap.bundle')
    expect(sprockets_manifest).not_to match(%r{//= require bootstrap\s*$})
  end

  it 'vendors a Bootstrap bundle aligned with package.json' do
    package = JSON.parse(Rails.root.join('package.json').read)
    vendor_bundle = Rails.root.join('app/assets/javascripts/vendor/bootstrap.bundle.js').read
    minor_release = package.fetch('dependencies').fetch('bootstrap').match(/(\d+\.\d+)/)[1]

    expect(vendor_bundle).to include("Bootstrap v#{minor_release}")
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
    it 'does not auto-run javascript:build in test (deploy uses production env too)' do
      Rails.application.load_tasks

      expect(Rake::Task['assets:precompile'].prerequisites).to include('dartsass:build')
      expect(Rake::Task['assets:precompile'].prerequisites).not_to include('javascript:build')
    end
  end
end
