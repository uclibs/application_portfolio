# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'esbuild javascript build', :build do
  it 'javascript:build produces app/assets/builds/application.js' do
    Rails.application.load_tasks
    %w[javascript:prepare_node_path javascript:install javascript:build].each do |name|
      Rake::Task[name].reenable
    end
    Rake::Task['javascript:build'].invoke

    bundle = Rails.root.join('app/assets/builds/application.js')
    expect(bundle).to exist
    expect(bundle.size).to be > 1000
    content = bundle.read
    expect(content).to match(/turbo/i)
    expect(content).to match(/chartkick|Chartkick/i)
    expect(content).to include('js-add-multivalue')
    expect(content).to match(/Dropdown|data-bs-toggle/i)
    expect(content).not_to include('@rails/ujs')
  end
end
