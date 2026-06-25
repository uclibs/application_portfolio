# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'assets:precompile' do
  let(:public_assets) { Rails.public_path.join('assets') }

  after do
    FileUtils.rm_rf(public_assets)
  end

  it 'fingerprints dartsass and esbuild outputs without explicit precompile entries' do
    QuietTestBuilds.precompile_assets!

    expect(Dir.children(public_assets).any? { |name| name.start_with?('.sprockets-manifest') }).to be(true)
    expect(CompiledAssetExpectations.fingerprinted_asset?(public_assets, 'application', '.js')).to be(true)
    expect(CompiledAssetExpectations.fingerprinted_asset?(public_assets, 'application', '.css')).to be(true)
    expect(CompiledAssetExpectations.fingerprinted_asset?(public_assets, 'software_records', '.css')).to be(true)
  end
end
