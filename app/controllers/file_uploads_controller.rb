# frozen_string_literal: true

# File Upload Controller
class FileUploadsController < ApplicationController
  layout 'software_records'
  include ApplicationHelper
  before_action :navigation
  before_action :authenticate_user!
  access root_admin: %i[new create]
  def new
    $page_title = 'Import Seed Data | UCL Application Portfolio'
    @file = FileUpload.new
  end

  def create
    $page_title = 'Import Seed Data | UCL Application Portfolio'
    @file = FileUpload.new(file_upload_params)
    uploaded_io = params[:file_upload][:attachment]

    # Sanitize the filename to remove any potentially malicious characters
    sanitized_filename = params[:file_upload][:attachment].original_filename.gsub(/[^a-zA-Z0-9_.]/, '')

    # Construct the safe path using Rails.root.join and the sanitized filename
    safe_path = File.join(Rails.root, 'public', 'uploads', sanitized_filename)

    File.open(safe_path, 'wb') do |file|
      file.write(uploaded_io.read)
    end

    filename = params[:file_upload][:attachment].original_filename
    option = params[:seed].to_s
    user = "#{current_user.first_name} #{current_user.last_name}"
    case option
    when 'srecords'
      system('cd../..')
      $output = system('ruby', 'load_records.rb', 'software', filename, user)
    when 'vrecords'
      system('cd../..')
      $output = system('ruby', 'load_records.rb', 'vendor', filename, user)
    when 'stypes'
      system('cd../..')
      $output = system('ruby', 'load_records.rb', 'type', filename, user)
    when 'status'
      system('cd../..')
      $output = system('ruby', 'load_records.rb', 'status', filename, user)
    when 'hosting_env'
      system('cd../..')
      $output = system('ruby', 'load_records.rb', 'hosting_env', filename, user)
    end

    # Sanitize the filename to remove any potentially malicious characters
    sanitized_filename = params[:file_upload][:attachment].original_filename.gsub(/[^a-zA-Z0-9_.]/, '')

    # Construct the safe path using Rails.root.join and the sanitized filename
    safe_path = File.join(Rails.root, 'public', 'uploads', sanitized_filename)

    File.open(safe_path, 'wb') do |file|
      file.write(uploaded_io.read)
    end

    File.delete(safe_path)
    redirect_to file_uploads_new_path,
                notice: "The file `#{uploaded_io.original_filename}` has been loaded successfully."
  rescue StandardError
    flash[:error] = 'Cannot process seed data without input file.'
    redirect_to file_uploads_new_path
  end

  private

  def file_upload_params
    params.require(:file_upload).permit(:name, :attachment)
  end
end
