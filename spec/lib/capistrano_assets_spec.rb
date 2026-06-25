# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Capistrano asset deploy tasks' do
  let(:assets_rake) { Rails.root.join('lib/capistrano/tasks/assets.rake').read }
  let(:assets_precompile_sh) { Rails.root.join('scripts/assets_precompile.sh').read }
  let(:check_node_sh) { Rails.root.join('scripts/check_node.sh').read }

  it 'overrides capistrano-rails deploy:assets:precompile with a bash wrapper script' do
    expect(assets_rake).to include("Rake::Task['deploy:assets:precompile'].clear_actions")
    expect(assets_rake).to include('within release_path')
    expect(assets_rake).to include("execute :bash, 'scripts/assets_precompile.sh'")
    expect(assets_rake).to include('release_roles(fetch(:assets_roles))')
  end

  it 'sources check_node.sh from the deploy wrapper script' do
    expect(assets_precompile_sh).to include('source scripts/check_node.sh')
    expect(assets_precompile_sh).to include('bundle exec rails assets:precompile')
  end

  it 'detects installed Node via nvm which and exports PATH for yarn' do
    expect(check_node_sh).to include('.nvmrc')
    expect(check_node_sh).to include('nvm which')
    expect(check_node_sh).to include('export PATH')
    expect(check_node_sh).to include('command -v yarn')
  end
end
