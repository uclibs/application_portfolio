# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'assets precompile' do
  it 'does not auto-run javascript:build in test (deploy uses production env too)' do
    Rails.application.load_tasks

    expect(Rake::Task['assets:precompile'].prerequisites).to include('dartsass:build')
    expect(Rake::Task['assets:precompile'].prerequisites).not_to include('javascript:build')
  end
end
