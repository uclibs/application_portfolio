# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Capistrano asset deploy tasks' do
  let(:assets_rake) { Rails.root.join('lib/capistrano/tasks/assets.rake').read }
  let(:check_node_sh) { Rails.root.join('scripts/check_node.sh').read }

  it 'overrides capistrano-rails deploy:assets:precompile with check_node sourcing' do
    expect(assets_rake).to include("Rake::Task['deploy:assets:precompile'].clear_actions")
    expect(assets_rake).to include('namespace :deploy do')
    expect(assets_rake).to include("execute 'source scripts/check_node.sh && bundle exec rails assets:precompile'")
    expect(assets_rake).to include('release_roles(fetch(:assets_roles))')
  end

  it 'detects installed Node via nvm which and exports PATH for yarn' do
    expect(check_node_sh).to include('.nvmrc')
    expect(check_node_sh).to include('nvm which')
    expect(check_node_sh).to include('export PATH')
    expect(check_node_sh).to include('command -v yarn')
  end
end
