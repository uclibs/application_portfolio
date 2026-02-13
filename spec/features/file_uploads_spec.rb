# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'File uploads (seed import)', type: :feature do
  let(:admin) { FactoryBot.create(:admin) }
  let(:csv_path) { Rails.root.join('spec', 'fixtures', 'files', 'software_records.csv').to_s }

  before do
    FileUtils.mkdir_p(Rails.root.join('public', 'uploads'))
    # Stub system on the controller instance (receiver of system() in the action) so load_records.rb is not run
    allow_any_instance_of(FileUploadsController).to receive(:system).and_return(true)

    visit new_user_session_path
    fill_in 'user_email', with: admin.email
    fill_in 'user_password', with: 'random1234'
    click_button 'Login'
  end

  scenario 'root_admin can upload a CSV and trigger import (create path)', js: false do
    visit file_uploads_new_path
    attach_file 'file_upload_attachment', csv_path
    choose 'seed_srecords'
    click_button 'Import Data'

    expect(page).to have_current_path(file_uploads_new_path)
    expect(page.body).to include('has been loaded successfully')
  end

  %w[vrecords stypes status hosting_env].each do |option|
    scenario "root_admin can upload and select #{option}", js: false do
      visit file_uploads_new_path
      attach_file 'file_upload_attachment', csv_path
      choose "seed_#{option}"
      click_button 'Import Data'

      expect(page).to have_current_path(file_uploads_new_path)
      expect(page.body).to include('has been loaded successfully')
    end
  end
end
