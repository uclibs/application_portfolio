# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'esbuild javascript build' do
  around do |example|
    example.run
  ensure
    FileUtils.rm_f(Rails.root.join('app/assets/builds/application.js'))
    FileUtils.rm_f(Rails.root.join('app/assets/builds/application.js.map'))
  end

  it 'yarn build produces app/assets/builds/application.js' do
    expect(system('yarn build')).to be(true)

    bundle = Rails.root.join('app/assets/builds/application.js')
    expect(bundle).to exist
    expect(bundle.read).to include('@hotwired/turbo-rails')
  end
end
