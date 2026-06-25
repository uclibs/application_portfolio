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
    expect(content).to include('flash-toast')
    expect(content).to include('navigation')
    expect(content).to include('show-tab')
    expect(content).to match(%r{@hotwired/stimulus|stimulus\.js})
    expect(content).to match(/Dropdown|data-bs-toggle/i)
    expect(content).to match(/activestorage|ActiveStorage/i)
    expect(content).not_to include('@rails/ujs')
  end

  def self.source_paths(source_glob = Rails.root.join('app/javascript/**/*.js'))
    [
      Rails.root.join('package.json'),
      Rails.root.join('yarn.lock'),
      *Dir.glob(source_glob.to_s)
    ].map(&:to_s).sort_by { |path| Pathname.new(path).relative_path_from(Rails.root).to_s }
  end

  def self.sources_digest(source_glob = Rails.root.join('app/javascript/**/*.js'))
    digest = Digest::SHA256.new

    source_paths(source_glob).each do |path|
      digest << "#{Pathname.new(path).relative_path_from(Rails.root)}:"
      digest << File.read(path)
    end

    digest.hexdigest
  end

  def self.record_sources_digest!(source_glob = Rails.root.join('app/javascript/**/*.js'))
    sources_digest_path.write(sources_digest(source_glob))
  end

  def self.stale_sources?(bundle_path, source_glob = Rails.root.join('app/javascript/**/*.js'))
    return true unless bundle_path.exist?
    return true unless bundle_path.size > 1000
    return true unless sources_digest_path.exist?

    sources_digest(source_glob) != sources_digest_path.read.strip
  end
end

RSpec.configure do |config|
  config.include EsbuildBundleExpectations
end
