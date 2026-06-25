# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Capistrano asset deploy tasks' do
  let(:assets_rake) { Rails.root.join('lib/capistrano/tasks/assets.rake').read }
  let(:assets_precompile_sh) { Rails.root.join('scripts/assets_precompile.sh').read }
  let(:check_node_sh) { Rails.root.join('scripts/check_node.sh').read }

  it 'overrides deploy:assets:precompile to run the wrapper script with SSHKit cd/env' do
    expect(assets_rake).to include("Rake::Task['deploy:assets:precompile'].clear_actions")
    expect(assets_rake).to include('within release_path')
    expect(assets_rake).to include("execute :bash, 'scripts/assets_precompile.sh'")
    expect(assets_rake).to include('release_roles(fetch(:assets_roles))')
    expect(assets_precompile_sh).to include('source scripts/check_node.sh')
    expect(assets_precompile_sh).to include('bundle exec rails assets:precompile')
    expect(assets_precompile_sh).to include('[ -f Gemfile ]')
  end

  it 'requires check_node.sh to be sourced and activates nvm Node for yarn' do
    expect(check_node_sh).to include('Source this script: source scripts/check_node.sh')
    expect(check_node_sh).to include('.nvmrc missing or empty')
    expect(check_node_sh).to include('nvm which')
    expect(check_node_sh).to include('process.versions.node')
    expect(check_node_sh).to include('export PATH')
    expect(check_node_sh).to include('command -v yarn')
  end
end
