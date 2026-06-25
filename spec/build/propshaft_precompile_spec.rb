# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'assets:precompile' do
  let(:public_assets) { Rails.public_path.join('assets') }

  after do
    FileUtils.rm_rf(public_assets)
  end

  it 'fingerprints dartsass and esbuild outputs via Propshaft' do
    QuietTestBuilds.precompile_assets!

    expect(public_assets.join('.manifest.json')).to exist
    expect(CompiledAssetExpectations.fingerprinted_asset?(public_assets, 'application', '.js')).to be(true)
    expect(CompiledAssetExpectations.fingerprinted_asset?(public_assets, 'application', '.css')).to be(true)
    expect(CompiledAssetExpectations.fingerprinted_asset?(public_assets, 'software_records', '.css')).to be(true)
    expect(Dir.glob(public_assets.join('**/*.scss'))).to be_empty
  end
end
