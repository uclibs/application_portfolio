# frozen_string_literal: true

# !/bin/env ruby
require 'csv'
require Dir.pwd + '/config/environment.rb'

# Export SoftwareRecords Data
class SoftwareRecords < ActiveRecord::Base
  def exportdata
    file = Dir.pwd + '/public/software_records.csv'
    software_records = SoftwareRecords.all

    headers = ['Software Record', 'Description', 'Status', 'Created on', 'Software Type', 'Vendor Record', 'Departments', 'Date Implemented', 'Date of upgrade', 'Developers', 'Tech Leads', 'Product Owners', 'Languages Used', 'Production URL', 'Source Code URL', 'User Seats', 'Annual Fees', 'Support Contract', 'Hosting Environment', 'Current Version', 'Notes', 'Business Value', 'IT Quality', 'Created By']

    CSV.open(file, 'w', write_headers: true, headers: headers) do |writer|
      software_records.each do |software_record|
        tech_leads = software_record.tech_leads.to_s.gsub!('---', '').to_s
        tech_leads = tech_leads.gsub!(/\n/, '-').to_s

        departments = software_record.departments.to_s.gsub!('---', '').to_s
        departments = departments.gsub!(/\n/, '-').to_s

        developers = software_record.developers.to_s.gsub!('---', '').to_s
        developers = developers.gsub!(/\n/, '-').to_s

        product_owners = software_record.product_owners.to_s.gsub!('---', '').to_s
        product_owners = product_owners.gsub!(/\n/, '-').to_s

        writer << [software_record.title, software_record.description, software_record.status, software_record.created_at, SoftwareType.find_by_id(software_record.software_type_id).title, VendorRecord.find_by_id(software_record.vendor_record_id).title, departments, software_record.date_implemented, software_record.date_of_upgrade, developers, tech_leads, product_owners, software_record.languages_used, software_record.production_url, software_record.source_code_url, software_record.user_seats, software_record.annual_fees, software_record.support_contract, software_record.hosting_environment, software_record.current_version, software_record.notes, software_record.business_value, software_record.it_quality, software_record.created_by]
      end
    end
  end
end

# Export SoftwareType Data
class SoftwareType < ActiveRecord::Base
  def exportdata
    file = Dir.pwd + '/public/software_types.csv'
    software_types = SoftwareType.all

    headers = ['SoftwareType ID', 'Created On', 'Software Type', 'Description']

    CSV.open(file, 'w', write_headers: true, headers: headers) do |writer|
      software_types.each do |software_type|
        writer << [software_type.id, software_type.created_at, software_type.title, software_type.description]
      end
    end
  end
end

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

args = ARGV[0]

if args == 'srecords'
  e = SoftwareRecords.new
  e.exportdata
elsif args == 'stypes'
  e = SoftwareType.new
  e.exportdata
else
  e = VendorRecord.new
  e.exportdata
end
