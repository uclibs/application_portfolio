# frozen_string_literal: true

# File Upload Controller
class FileUploadsController < ApplicationController
  layout 'software_records'
  before_action :authenticate_user!
  access root_admin: %i[new create]
  def new
    $page_title = 'Import Seed Data | Application Portfolio'
    @file = FileUpload.new
  end

  def create
    $page_title = 'Import Seed Data | Application Portfolio'
    @file = FileUpload.new(file_upload_params)
    uploaded_io = params[:file_upload][:attachment]
    File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
    end
    filename = params[:file_upload][:attachment].original_filename
    option = params[:seed].to_s

    if option == 'srecords'
      system('cd../..')
      $output = `ruby load_records.rb software "#{filename}"`
    elsif option == 'vrecords'
      system('cd../..')
      $output = `ruby load_records.rb vendor "#{filename}"`
    elsif option == 'stypes'
      system('cd../..')
      $output = `ruby load_records.rb type "#{filename}"`
    end
    File.delete(Rails.root.join('public', 'uploads', uploaded_io.original_filename))
    redirect_to file_uploads_new_path, notice: "The file `#{uploaded_io.original_filename}` has been loaded successfully."
  rescue StandardError
    flash[:error] = 'Cannot process seed data without input file.'
    redirect_to file_uploads_new_path
  end

  private

  def file_upload_params
    params.require(:file_upload).permit(:name, :attachment)
  end
end
