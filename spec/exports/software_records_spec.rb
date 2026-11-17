# frozen_string_literal: true

require 'rails_helper'
require 'csv'

# Loading defines SoftwareRecords and writes the CSV from whatever is already stored.
# Remove that file immediately; examples write it again from their own records.
load Rails.root.join('exports/software_records.rb').to_s
FileUtils.rm_f(Rails.root.join('public/software_records.csv'))

RSpec.describe SoftwareRecords, '#software_records' do
  let(:csv_path) { Rails.root.join('public/software_records.csv') }
  let(:exporter) { described_class.new }

  after { FileUtils.rm_f(csv_path) }

  it 'writes every active record and skips decommissioned records' do
    live = FactoryBot.create(:status, title: 'Live', status_type: 'Active')
    active = FactoryBot.create(:status, title: 'Active', status_type: 'Active')
    retired = FactoryBot.create(:status, title: 'Retired', status_type: 'Decommissioned')
    software_type = FactoryBot.create(:software_type, title: 'Web App')
    vendor = FactoryBot.create(:vendor_record, title: 'Acme')
    hosting = FactoryBot.create(:hosting_environment, title: 'AWS')

    populated = FactoryBot.create(
      :software_record,
      title: 'Portal',
      status: live,
      software_type: software_type,
      vendor_record: vendor,
      hosting_environment: hosting,
      departments: %w[Alpha Beta],
      developers: %w[Ann],
      tech_leads: %w[Tia],
      product_owners: %w[Pat],
      admin_users: %w[Ada],
      business_value: 5,
      it_quality: 3,
      requires_cm: 'yes',
      track_uptime: 'yes',
      monitor_health: 'yes',
      monitor_errors: 'yes',
      road_map: 'Q1 launch'
    )
    sparse = FactoryBot.create(:software_record, title: 'Sparse', status: active)
    sparse.update_columns(software_type_id: nil, vendor_record_id: nil, hosting_environment_id: nil)
    FactoryBot.create(:software_record, title: 'Retired App', status: retired)

    exporter.software_records
    rows = CSV.parse(csv_path.read, headers: true)
    by_title = rows.index_by { |row| row['Software Record'] }

    expect(rows.headers).to eq(
      [
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
        'Monitor Health', 'Monitor Errors', 'Road Map'
      ]
    )
    expect(by_title.keys).to contain_exactly('Portal', 'Sparse')

    expect(by_title['Portal'].fields).to eq(
      [
        populated.title, populated.description, 'Live', populated.created_at.to_s, 'Web App',
        populated.authentication_type, 'Acme', '["Alpha", "Beta"]',
        populated.date_implemented.to_s, populated.date_of_upgrade.to_s,
        '["Ann"]', '["Tia"]', '["Pat"]', '["Ada"]',
        populated.languages_used, populated.production_url, populated.source_code_url,
        populated.user_seats.to_s, populated.annual_fees.to_s, populated.support_contract, 'AWS',
        populated.current_version, populated.notes, '5', '3', populated.created_by, 'yes',
        populated.last_security_scan.to_s, populated.last_accessibility_scan.to_s,
        populated.last_ogc_review.to_s, populated.last_info_sec_review.to_s,
        populated.cm_stakeholders, populated.cm_other_notes, populated.qa_url,
        populated.dev_url, populated.prod_url, populated.production_support_servers,
        populated.last_record_change.to_s, 'yes', 'yes', 'yes', 'Q1 launch'
      ]
    )

    expect(by_title['Sparse']['Status']).to eq('Active')
    expect(by_title['Sparse']['Software Type']).to be_nil
    expect(by_title['Sparse']['Vendor Record']).to be_nil
    expect(by_title['Sparse']['Hosting Environment']).to be_nil
    expect(by_title['Sparse']['Departments']).to eq('')
    expect(by_title['Sparse']['Developers']).to eq('')
    expect(by_title['Sparse']['Tech Leads']).to eq('')
    expect(by_title['Sparse']['Product Owners']).to eq('')
    expect(by_title['Sparse']['Admin Users']).to eq('')
  end

  describe 'list formatting' do
    it 'returns an empty string for blank values' do
      expect(exporter.send(:clean_and_format, nil)).to eq('')
      expect(exporter.send(:clean_and_format, '')).to eq('')
      expect(exporter.send(:clean_and_format, [])).to eq('')
    end

    it 'joins a YAML list and drops dash-only fragments' do
      yaml = "---\n- Alpha\n- Beta"

      expect(exporter.send(:clean_and_format, yaml)).to eq('Alpha, Beta')
    end
  end
end
