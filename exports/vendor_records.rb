# frozen_string_literal: true

# !/bin/env ruby
require 'csv'
require "#{Dir.pwd}/config/environment.rb"

# Export VendorRecords Data
class VendorRecords < ApplicationRecord
  def vendor_records
    file = "#{Dir.pwd}/public/vendor_records.csv"
    vendor_records = VendorRecord.all

    headers = ['VendorRecord ID', 'Created On', 'Vendor Record', 'Description']

    CSV.open(file, 'w', write_headers: true, headers: headers) do |writer|
      vendor_records.each do |vendor_record|
        writer << [vendor_record.id, vendor_record.created_at, vendor_record.title,
                   vendor_record.description]
      end
    end
  end
end

vendor = VendorRecords.new
vendor.vendor_records
