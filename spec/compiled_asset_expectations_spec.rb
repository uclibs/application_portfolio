# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompiledAssetExpectations do
  describe '.fingerprinted_asset?' do
    it 'returns true when a matching fingerprinted file exists' do
      Dir.mktmpdir do |dir|
        File.write(File.join(dir, 'application-deadbeef.js'), 'x')

        expect(described_class.fingerprinted_asset?(dir, 'application', '.js')).to be(true)
      end
    end

    it 'returns false when only a different extension matches the prefix' do
      Dir.mktmpdir do |dir|
        File.write(File.join(dir, 'application-deadbeef.css'), 'x')

        expect(described_class.fingerprinted_asset?(dir, 'application', '.js')).to be(false)
      end
    end

    it 'returns false when no file shares the logical name prefix' do
      Dir.mktmpdir do |dir|
        File.write(File.join(dir, 'trix-deadbeef.js'), 'x')

        expect(described_class.fingerprinted_asset?(dir, 'application', '.js')).to be(false)
      end
    end

    it 'returns false when the directory is empty' do
      Dir.mktmpdir do |dir|
        expect(described_class.fingerprinted_asset?(dir, 'application', '.js')).to be(false)
      end
    end
  end
end
