# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'esbuild javascript build', :build do
  around do |example|
    example.run
  ensure
    EsbuildBuildArtifacts.remove!
  end

  it 'javascript:build produces app/assets/builds/application.js' do
    Rails.application.load_tasks
    %w[javascript:prepare_node_path javascript:install javascript:build].each do |name|
      Rake::Task[name].reenable
    end
    Rake::Task['javascript:build'].invoke

    bundle = Rails.root.join('app/assets/builds/application.js')
    expect(bundle).to exist
    expect(bundle.size).to be > 1000
    expect(bundle.read).to match(/turbo/i)
    expect(bundle.read).not_to include('@rails/ujs')
  end
end
