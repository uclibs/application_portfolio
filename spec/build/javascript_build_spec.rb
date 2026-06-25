# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'esbuild javascript build' do
  it 'javascript:build produces app/assets/builds/application.js' do
    QuietTestBuilds.invoke_javascript_build!

    bundle = Rails.root.join('app/assets/builds/application.js')
    expect(bundle).to exist
    expect(bundle.size).to be > 1000
    expect_core_bundle_content!(bundle.read)
  end
end
