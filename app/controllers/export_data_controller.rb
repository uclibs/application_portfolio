# frozen_string_literal: true

# ExportData Controller
class ExportDataController < ApplicationController
  layout 'software_records'
  before_action :authenticate_user!
  access root_admin: :all, owner: :all

  def software_records
    system('cd../..')
    $export = `ruby exports/software_records.rb`
    send_file "#{Dir.pwd}/public/software_records.csv", disposition: 'attachment'
  end

  def software_types
    system('cd../..')
    $export = `ruby exports/software_types.rb`
    send_file "#{Dir.pwd}/public/software_types.csv", disposition: 'attachment'
  end

  def vendor_records
    system('cd../..')
    $export = `ruby exports/vendor_records.rb`
    send_file "#{Dir.pwd}/public/vendor_records.csv", disposition: 'attachment'
  end

  def change_requests
    system('cd../..')
    $export = `ruby exports/change_requests.rb`
    send_file "#{Dir.pwd}/public/change_requests.csv", disposition: 'attachment'
  end
end
