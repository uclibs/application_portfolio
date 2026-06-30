# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CI scripts' do
  let(:workflow) { Rails.root.join('.github/workflows/ci_checks.yml').read }

  it 'runs lint and security checks in parallel without Node' do
    expect(workflow).to include('matrix:')
    expect(workflow).to include('rubocop')
    expect(workflow).to include('brakeman')
    expect(workflow).to include('bundler_audit')
  end

  it 'avoids duplicate runs on feature-branch pushes that update a pull request' do
    expect(workflow).to include('branches: [qa, main]')
    expect(workflow).to include('branches: [qa]')
    expect(workflow).to include('types: [opened, synchronize, reopened, ready_for_review]')
  end

  it 'runs tests on GitHub-hosted ubuntu runners with Node and Chrome' do
    expect(workflow).to include('runs-on: ubuntu-24.04')
    expect(workflow).to include('actions/setup-node@v4')
    expect(workflow).to include('browser-actions/setup-chrome@v1')
    expect(workflow).to include('install-chromedriver: true')
    expect(workflow).to include('CHROMEDRIVER_PATH')
    expect(workflow).to include('./scripts/ci/build_assets.sh')
    expect(workflow).to include('./scripts/ci/run_tests.sh')
  end

  it 'does not use setup-node yarn cache before Corepack activates Yarn 4' do
    expect(workflow).not_to include('cache: yarn')
    expect(workflow).to include('yarn4-node-modules')
    expect(workflow).to include('./scripts/ci/setup_javascript_dependencies.sh')
    expect(workflow).to include("steps.node-modules-cache.outputs.cache-hit != 'true'")
    expect(workflow).to include('continue-on-error: true')
  end

  it 'uploads coverage and enforces the baseline on pull requests' do
    expect(workflow).to include('name: coverage-report')
    expect(workflow).to include('coverage-update:')
    expect(workflow).to include('./scripts/ci/coverage_gate.sh')
    expect(workflow).not_to include('coveralls')
  end

  it 'keeps a committed coverage baseline for the gate' do
    baseline = Rails.root.join('coverage/coverage_baseline.txt')
    expect(baseline).to exist
    expect(baseline.read.strip).to match(/\A\d+\.\d+\z/)
  end
end
