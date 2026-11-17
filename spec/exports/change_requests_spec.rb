# frozen_string_literal: true

require 'rails_helper'
require 'csv'

# The script reopens ChangeRequest. Load it for this group only, then remove
# the methods so later examples keep the model that the application defined.
RSpec.describe ChangeRequest, '#export' do
  let(:csv_path) { Rails.root.join('public/change_requests.csv') }

  before(:context) do
    load Rails.root.join('exports/change_requests.rb').to_s
  end

  after { FileUtils.rm_f(csv_path) }

  after(:context) do
    ChangeRequest.undef_method(:export) if ChangeRequest.method_defined?(:export)
    return unless ChangeRequest.private_method_defined?(:clean_and_format)

    ChangeRequest.send(:undef_method, :clean_and_format)
    FileUtils.rm_f(Rails.root.join('public/change_requests.csv'))
  end

  it 'writes change requests for active software and skips decommissioned software' do
    active = FactoryBot.create(:status, title: 'Active', status_type: 'Active')
    retired = FactoryBot.create(:status, title: 'Retired', status_type: 'Decommissioned')
    portal = FactoryBot.create(:software_record, title: 'Portal', status: active)
    hidden = FactoryBot.create(:software_record, title: 'Hidden App', status: active)
    retired_app = FactoryBot.create(:software_record, title: 'Retired App', status: retired)

    populated = FactoryBot.create(
      :change_request,
      software_record: portal,
      change_title: 'Add login',
      change_description: "---\n- Do this\n- And that\n- Maybe more---",
      change_submitted_date: Date.new(2024, 1, 2),
      change_completed: false,
      change_scheduled_date: Date.new(2024, 2, 3),
      change_completed_date: Date.new(2024, 3, 4),
      manager_first_name: 'Ann',
      manager_last_name: 'Lee',
      manager_work_phone: '555-0100',
      manager_contact_phone: '555-0101',
      manager_department: 'Libraries',
      manager_email: 'ann@example.edu',
      director_first_name: 'Pat',
      director_last_name: 'Kim',
      director_work_phone: '555-0200',
      director_contact_phone: '555-0201',
      director_department: 'IT',
      director_email: 'pat@example.edu',
      application_pages: 4,
      number_roles: 2,
      authentication_needed: true,
      custom_error_pages: false
    )
    FactoryBot.create(
      :change_request,
      software_record: hidden,
      change_title: 'Hide me',
      change_description: nil
    )
    FactoryBot.create(:change_request, software_record: retired_app, change_title: 'Do not export')

    ChangeRequest.new.export
    rows = CSV.parse(csv_path.read, headers: true)
    by_title = rows.index_by { |row| row['Change Title'] }

    expect(rows.headers).to eq(
      [
        'Software Record Title', 'Change Title', 'Change Description', 'Submitted Date',
        'Completed?', 'Scheduled Date', 'Completed Date',
        'Manager First Name', 'Manager Last Name', 'Manager Work Phone',
        'Manager Contact Phone', 'Manager Department', 'Manager Email',
        'Director First Name', 'Director Last Name', 'Director Work Phone',
        'Director Contact Phone', 'Director Department', 'Director Email',
        'Application Pages', 'Number of Roles', 'Authentication Needed?',
        'Custom Error Pages?', 'Created At', 'Updated At'
      ]
    )
    expect(by_title.keys).to contain_exactly('Add login', 'Hide me')
    expect(by_title['Add login'].fields).to eq(
      [
        'Portal', 'Add login', 'Do this, And that, Maybe more', '2024-01-02',
        'false', '2024-02-03', '2024-03-04',
        'Ann', 'Lee', '555-0100', '555-0101', 'Libraries', 'ann@example.edu',
        'Pat', 'Kim', '555-0200', '555-0201', 'IT', 'pat@example.edu',
        '4', '2', 'true', 'false',
        populated.created_at.to_s, populated.updated_at.to_s
      ]
    )
    expect(by_title['Hide me']['Software Record Title']).to eq('Hidden App')
    expect(by_title['Hide me']['Change Description']).to eq('')
  end

  it 'returns an empty string when the description is blank' do
    expect(ChangeRequest.new.send(:clean_and_format, nil)).to eq('')
  end
end
