# frozen_string_literal: true

# !/bin/env ruby
require 'csv'
require Dir.pwd + '/config/environment.rb'

# Export VendorRecords Data
class VendorRecord < ActiveRecord::Base
  def exportdata
    file = Dir.pwd + '/public/vendor_records.csv'
    vendor_records = VendorRecord.all

    headers = ['VendorRecord ID', 'Created On', 'Vendor Record', 'Description']

    CSV.open(file, 'w', write_headers: true, headers: headers) do |writer|
      vendor_records.each do |vendor_record|
        writer << [vendor_record.id, vendor_record.created_at, vendor_record.title, vendor_record.description]
      end
    end
  end
end

e = VendorRecord.new
e.exportdata
