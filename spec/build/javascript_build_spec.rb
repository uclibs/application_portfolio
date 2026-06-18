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
    skip 'Run `nvm use && yarn install` to install JavaScript dependencies' unless JavascriptBuild.dependencies_installed?

    JavascriptBuild.run!

    bundle = Rails.root.join('app/assets/builds/application.js')
    expect(bundle).to exist
    expect(bundle.size).to be > 1000
    expect(bundle.read).to match(/turbo/i)
  end
end
