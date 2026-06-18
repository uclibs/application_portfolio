# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'esbuild javascript build' do
  around do |example|
    example.run
  ensure
    FileUtils.rm_f(Rails.root.join('app/assets/builds/application.js'))
    FileUtils.rm_f(Rails.root.join('app/assets/builds/application.js.map'))
  end

  it 'javascript:build produces app/assets/builds/application.js' do
    Rails.application.load_tasks
    Rake::Task['javascript:install'].reenable
    Rake::Task['javascript:build'].reenable
    Rake::Task['javascript:build'].invoke

    bundle = Rails.root.join('app/assets/builds/application.js')
    expect(bundle).to exist
    expect(bundle.size).to be > 1000
    expect(bundle.read).to match(/turbo/i)
  end
end
