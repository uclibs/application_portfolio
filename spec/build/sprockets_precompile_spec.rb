# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'assets:precompile', :build do
  let(:public_assets) { Rails.public_path.join('assets') }

  after do
    FileUtils.rm_rf(public_assets)
  end

  it 'fingerprints dartsass and esbuild outputs without explicit precompile entries' do
    FileUtils.rm_rf(public_assets)

    Rails.application.load_tasks
    Rake::Task['dartsass:build'].reenable
    Rake::Task['dartsass:build'].invoke
    Rake::Task['assets:precompile'].reenable
    Rake::Task['assets:precompile'].invoke

    compiled = Dir.children(public_assets)
    expect(compiled.any? { |name| name.start_with?('.sprockets-manifest') }).to be(true)
    expect(compiled.any? { |name| name.start_with?('application-') && name.end_with?('.js') }).to be(true)
    expect(compiled.any? { |name| name.start_with?('software_records-') && name.end_with?('.css') }).to be(true)
  end
end
