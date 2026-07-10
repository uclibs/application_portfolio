# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'File uploads (seed import)', type: :feature do
  let(:admin) { FactoryBot.create(:admin) }
  let(:csv_path) { Rails.root.join('spec', 'fixtures', 'files', 'software_records.csv').to_s }
  let(:upload_dir) { Rails.root.join('public', 'uploads') }

  before do
    FileUtils.mkdir_p(upload_dir)
    # Stub system on the controller instance (receiver of system() in the action) so load_records.rb is not run
    allow_any_instance_of(FileUploadsController).to receive(:system).and_return(true)

    visit new_user_session_path
    fill_in 'user_email', with: admin.email
    click_button 'Login'
  end

  after do
    FileUtils.rm_f(Dir[upload_dir.join('*')])
  end

  scenario 'root_admin can upload a CSV and trigger import (create path)', js: false do
    visit file_uploads_new_path
    attach_file 'file_upload_attachment', csv_path
    choose 'seed_srecords'
    click_button 'Import Data'

    expect(page).to have_current_path(file_uploads_new_path)
    expect(page.body).to include('flash-toast')
    expect(page.body).to include('has been loaded successfully')
    expect(Dir[upload_dir.join('*').to_s]).to be_empty
  end

  scenario 'root_admin upload sanitizes an unsafe filename and removes the temporary file', js: false do
    unsafe_path = Rails.root.join('tmp', 'unsafe records!.csv')
    FileUtils.cp(csv_path, unsafe_path)

    visit file_uploads_new_path
    attach_file 'file_upload_attachment', unsafe_path.to_s
    choose 'seed_srecords'
    click_button 'Import Data'

    expect(page).to have_current_path(file_uploads_new_path)
    expect(page.body).to include('flash-toast')
    expect(page.body).to include('has been loaded successfully')
    expect(File.exist?(upload_dir.join('unsaferecords.csv'))).to be(false)
  ensure
    FileUtils.rm_f(unsafe_path)
  end

  %w[vrecords stypes status hosting_env].each do |option|
    scenario "root_admin can upload and select #{option}", js: false do
      visit file_uploads_new_path
      attach_file 'file_upload_attachment', csv_path
      choose "seed_#{option}"
      click_button 'Import Data'

      expect(page).to have_current_path(file_uploads_new_path)
      expect(page.body).to include('has been loaded successfully')
      expect(Dir[upload_dir.join('*').to_s]).to be_empty
    end
  end
end
