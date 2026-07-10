# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'scripts/corepack_yarn.sh' do
  let(:script) { Rails.root.join('scripts/corepack_yarn.sh').read }

  it 'defines sourceable Corepack helpers and a direct-run entry point' do
    expect(script).to include('setup_corepack_yarn')
    expect(script).to include('run_yarn')
    expect(script).to include('run_corepack')
    expect(script).to include('BASH_SOURCE[0]')
  end

  it 'resolves Corepack from the active Node and falls back to npm install' do
    expect(script).to include('lib/node_modules/corepack/dist/corepack.js')
    expect(script).to include('command -v corepack')
    expect(script).to include('npm install -g corepack')
    expect(script).to include('--install-directory')
  end

  it 'prepares Yarn from package.json packageManager' do
    expect(script).to include('packageManager')
    expect(script).to include('^4\\.')
  end
end
