# frozen_string_literal: true

module EsbuildBundleExpectations
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
end

RSpec.configure do |config|
  config.include EsbuildBundleExpectations
end
