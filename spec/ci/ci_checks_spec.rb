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

  it 'runs tests on GitHub-hosted ubuntu runners with Node and Chrome' do
    expect(workflow).to include('runs-on: ubuntu-24.04')
    expect(workflow).to include('actions/setup-node@v4')
    expect(workflow).to include('browser-actions/setup-chrome@v1')
    expect(workflow).to include('./scripts/ci/build_assets.sh')
    expect(workflow).to include('./scripts/ci/run_tests.sh')
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
