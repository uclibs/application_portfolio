# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'assets pipeline' do
  let(:sprockets_manifest) { Rails.root.join('app/assets/javascripts/application.js').read }
  let(:gemfile_lock) { Rails.root.join('Gemfile.lock').read }

  it 'does not require jquery in the Sprockets manifest' do
    expect(sprockets_manifest).not_to match(/require jquery/i)
  end

  it 'does not list jquery-rails in Gemfile.lock' do
    expect(gemfile_lock).not_to include('jquery-rails')
  end

  describe 'assets:precompile task' do
    it 'does not auto-run javascript:build in test (deploy uses production env too)' do
      Rails.application.load_tasks

      expect(Rake::Task['assets:precompile'].prerequisites).to include('dartsass:build')
      expect(Rake::Task['assets:precompile'].prerequisites).not_to include('javascript:build')
    end
  end
end
