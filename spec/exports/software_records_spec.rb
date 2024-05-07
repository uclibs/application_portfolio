# frozen_string_literal: true

require "#{Dir.pwd}/exports/software_records.rb"
require 'rails_helper'
require 'csv'

RSpec.describe SoftwareRecords do
  describe '#software_records' do
    let(:software_records) { SoftwareRecords.new }

    before do
      FactoryBot.create(:software_record, tech_leads: nil, departments: nil, developers: nil,
                                          product_owners: nil, admin_users: nil)
    end

    it 'exports CSV with appropriate headers' do
      csv_content = File.read("#{Dir.pwd}/public/software_records.csv")
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

      expect(CSV.parse(csv_content, headers: true).headers).to eq(headers)
    end

    it 'includes nil attributes as empty fields' do
      csv_content = File.read("#{Dir.pwd}/public/software_records.csv")
      csv_rows = CSV.parse(csv_content, headers: true)

      csv_rows.each do |row|
        expect(row['Tech Leads']).to eq('')
        expect(row['Departments']).to eq('')
        expect(row['Developers']).to eq('')
        expect(row['Product Owners']).to eq('')
        expect(row['Admin Users']).to eq('')
      end
    end
  end
end
