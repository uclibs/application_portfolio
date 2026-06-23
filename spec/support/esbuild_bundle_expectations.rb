# frozen_string_literal: true

module EsbuildBundleExpectations
  def expect_core_bundle_content!(content)
    expect(content).to match(/turbo/i)
    expect(content).to match(/chartkick|Chartkick/i)
    expect(content).to include('js-add-multivalue')
    expect(content).to match(/Dropdown|data-bs-toggle/i)
    expect(content).to match(/activestorage|ActiveStorage/i)
    expect(content).not_to include('@rails/ujs')
  end

  def self.stale_sources?(bundle_path, source_glob)
    return true unless bundle_path.exist?

    bundle_mtime = File.mtime(bundle_path)
    Dir.glob(source_glob.to_s).any? { |path| File.mtime(path) > bundle_mtime }
  end
end

RSpec.configure do |config|
  config.include EsbuildBundleExpectations
end
