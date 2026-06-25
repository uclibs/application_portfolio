# frozen_string_literal: true

require 'digest'

module EsbuildBundleExpectations
  def self.sources_digest_path
    Rails.root.join('app/assets/builds/application.js.sources.sha256')
  end

  def expect_core_bundle_content!(content)
    expect(content).to match(/turbo/i)
    expect(content).to match(/chartkick|Chartkick/i)
    expect(content).to include('multi-value-inputs')
    expect(content).to include('filter-management')
    expect(content).to match(%r{@hotwired/stimulus|stimulus\.js})
    expect(content).to match(/Dropdown|data-bs-toggle/i)
    expect(content).to match(/activestorage|ActiveStorage/i)
    expect(content).not_to include('@rails/ujs')
  end

  def self.sources_digest(source_glob = Rails.root.join('app/javascript/**/*.js'))
    digest = Digest::SHA256.new
    inputs = [Rails.root.join('package.json'), *Dir.glob(source_glob.to_s)]
             .map(&:to_s)
             .sort_by { |path| Pathname.new(path).relative_path_from(Rails.root).to_s }

    inputs.each do |path|
      digest << "#{Pathname.new(path).relative_path_from(Rails.root)}:"
      digest << File.read(path)
    end

    digest.hexdigest
  end

  def self.stale_sources?(bundle_path, source_glob)
    return true unless bundle_path.exist?
    return true unless sources_digest_path.exist?

    sources_digest(source_glob) != sources_digest_path.read.strip
  end
end

RSpec.configure do |config|
  config.include EsbuildBundleExpectations
end
