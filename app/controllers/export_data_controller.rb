# frozen_string_literal: true

# ExportData Controller
class ExportDataController < ApplicationController
  layout 'software_records'
  before_action :authenticate_user!
  access root_admin: :all, owner: :all

  def software_records
    system('cd../..')
    $export = `ruby export_data.rb srecords`
    send_file Dir.pwd + '/public/software_records.csv', disposition: 'attachment'
  end

  def software_types
    system('cd../..')
    $export = `ruby export_data.rb stypes`
    send_file Dir.pwd + '/public/software_types.csv', disposition: 'attachment'
  end

  def vendor_records
    system('cd../..')
    $export = `ruby export_data.rb vrecords`
    send_file Dir.pwd + '/public/vendor_records.csv', disposition: 'attachment'
  end
end
