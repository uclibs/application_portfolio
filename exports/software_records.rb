# frozen_string_literal: true

# !/bin/env ruby
require 'csv'
require "#{Dir.pwd}/config/environment.rb"

# Export SoftwareRecords Data
class SoftwareRecords < ApplicationRecord
  def software_records
    file = "#{Dir.pwd}/public/software_records.csv"
    software_records = SoftwareRecords.all

    headers = [
      'Software Record', 'Description', 'Status', 'Created on', 'Software Type',
      'Authentication Type', 'Vendor Record', 'Departments', 'Date Implemented',
      'Date of upgrade', 'Developers', 'Tech Leads', 'Product Owners',
      'Admin Users', 'Languages Used', 'Production URL', 'Source Code URL',
      'User Seats', 'Annual Fees', 'Support Contract', 'Hosting Environment',
      'Current Version', 'Notes', 'Business Value', 'IT Quality', 'Created By',
      'Requires Change Management review?', 'Last Security Scan',
      'Last Accessibility Scan', 'Last OGC Review', 'Last Infosec Review',
      'CM Stakeholders', 'CM Other Notes', 'QA URL', 'Dev_URL', 'Prod_URL',
      'Production Support Servers', 'Last Record Change', 'Track Uptime',
      'Monitor Health', 'Monitor Errors'
    ]

    CSV.open(file, 'w', write_headers: true, headers:) do |writer|
      software_records.each do |software_record|
        writer << [
          software_record.title, software_record.description,
          Status.find_by(id: software_record.status_id)&.title,
          software_record.created_at,
          SoftwareType.find_by(id: software_record.software_type_id)&.title,
          software_record.authentication_type,
          VendorRecord.find_by(id: software_record.vendor_record_id)&.title,
          clean_and_format(software_record.departments),
          software_record.date_implemented, software_record.date_of_upgrade,
          clean_and_format(software_record.developers),
          clean_and_format(software_record.tech_leads),
          clean_and_format(software_record.product_owners),
          clean_and_format(software_record.admin_users),
          software_record.languages_used, software_record.production_url,
          software_record.source_code_url, software_record.user_seats,
          software_record.annual_fees, software_record.support_contract,
          HostingEnvironment.find_by(id: software_record.hosting_environment_id)&.title,
          software_record.current_version, software_record.notes,
          software_record.business_value, software_record.it_quality,
          software_record.created_by, software_record.requires_cm,
          software_record.last_security_scan, software_record.last_accessibility_scan,
          software_record.last_ogc_review, software_record.last_info_sec_review,
          software_record.cm_stakeholders, software_record.cm_other_notes,
          software_record.qa_url, software_record.dev_url, software_record.prod_url,
          software_record.production_support_servers, software_record.last_record_change,
          software_record.track_uptime, software_record.monitor_health,
          software_record.monitor_errors
        ]
      end
    end
  end

  private

  def clean_and_format(attribute)
    formatted_attribute = attribute.to_s.gsub('---', '').gsub("\n", '-')
    parts = formatted_attribute.split('- ').reject { |part| part == '-' }
    parts.map { |part| part.gsub('-', '').strip }.join(', ')
  end
end

records = SoftwareRecords.new
records.software_records
