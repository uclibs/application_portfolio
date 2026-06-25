# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Capistrano asset deploy tasks' do
  let(:assets_rake) { Rails.root.join('lib/capistrano/tasks/assets.rake').read }
  let(:check_node_sh) { Rails.root.join('scripts/check_node.sh').read }

  it 'sources check_node.sh in the same shell as assets:precompile' do
    expect(assets_rake).to include('source scripts/check_node.sh')
    expect(assets_rake).to include('bundle exec rails assets:precompile')
  end

  it 'detects installed Node via nvm which and exports PATH for yarn' do
    expect(check_node_sh).to include('.nvmrc')
    expect(check_node_sh).to include('nvm which')
    expect(check_node_sh).to include('export PATH')
    expect(check_node_sh).to include('command -v yarn')
  end
end
