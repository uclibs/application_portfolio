# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'JavaScript conventions' do
  let(:esbuild_bundle) { Rails.root.join('app/assets/builds/application.js') }

  it 'does not track the esbuild bundle in git' do
    tracked = `git -C #{Rails.root} ls-files -- app/assets/builds/application.js`.strip
    expect(tracked).to be_empty
  end

  it 'gitignores generated JavaScript build artifacts' do
    gitignore = Rails.root.join('.gitignore').read

    expect(gitignore).to include('/app/assets/builds/*')
    expect(gitignore).not_to include('!/app/assets/builds/application.js')
  end

  it 'does not use inline onclick handlers in app views' do
    Dir.glob(Rails.root.join('app/views/**/*.erb')).each do |path|
      expect(File.read(path)).not_to match(/\bonclick\s*=/), "#{path} uses inline onclick"
    end
  end

  it 'does not export inline-handler globals onto window in JavaScript sources' do
    Dir.glob(Rails.root.join('app/javascript/**/*.js')).each do |path|
      content = File.read(path)
      expect(content).not_to match(/window\.(openNav|closeNav|handleRadio|clearFiltersAndRedirect)\b/),
                             "#{path} assigns window globals for inline handlers"
    end
  end

  it 'ships Stimulus-driven behaviors in the esbuild bundle' do
    expect(esbuild_bundle).to exist

    expect_core_bundle_content!(esbuild_bundle.read)
  end
end
