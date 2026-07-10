# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EsbuildBundleExpectations do
  describe '.stale_sources?' do
    let(:tmpdir) { Rails.root.join('tmp/esbuild_stale_check') }
    let(:bundle_path) { tmpdir.join('application.js') }
    let(:digest_path) { tmpdir.join('application.js.sources.sha256') }

    before do
      FileUtils.mkdir_p(tmpdir)
      allow(described_class).to receive(:sources_digest_path).and_return(digest_path)
    end

    after { FileUtils.rm_rf(tmpdir) }

    it 'is stale when the bundle is missing' do
      expect(described_class.stale_sources?(bundle_path)).to be(true)
    end

    it 'is fresh when the bundle matches the recorded source digest' do
      bundle_path.write('x' * 1001)
      digest_path.write(described_class.sources_digest)

      expect(described_class.stale_sources?(bundle_path)).to be(false)
    end
  end
end
