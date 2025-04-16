# frozen_string_literal: true

require "#{Dir.pwd}/exports/change_requests.rb"
require 'rails_helper'
require 'csv'

RSpec.describe ChangeRequest do
  describe '#export' do
    let(:exporter) { described_class.new }
    let(:csv_path) { "#{Dir.pwd}/public/change_requests.csv" }

    before do
      status = FactoryBot.create(:status, status_type: 'Active')
      software_record = FactoryBot.create(:software_record, status: status)
      FactoryBot.create(:change_request,
                        software_record: software_record,
                        director_work_phone: nil,
                        director_contact_phone: nil,
                        director_department: nil,
                        change_description: '---\n- Do this\n- And that\n- Maybe more---')
    end

    it 'exports CSV with appropriate headers' do
      csv_content = File.read(csv_path)
      headers = [
        'Software Record Title', 'Change Title', 'Change Description', 'Submitted Date',
        'Completed?', 'Scheduled Date', 'Completed Date',
        'Manager First Name', 'Manager Last Name', 'Manager Work Phone',
        'Manager Contact Phone', 'Manager Department', 'Manager Email',
        'Director First Name', 'Director Last Name', 'Director Work Phone',
        'Director Contact Phone', 'Director Department', 'Director Email',
        'Application Pages', 'Number of Roles', 'Authentication Needed?',
        'Custom Error Pages?', 'Created At', 'Updated At'
      ]

      expect(CSV.parse(csv_content, headers: true).headers).to eq(headers)
    end

    it 'includes nil attributes as empty fields' do
      csv_content = File.read(csv_path)
      csv_rows = CSV.parse(csv_content, headers: true)

      csv_rows.each do |row|
        expect(row['Director Work Phone']).to eq('')
        expect(row['Director Contact Phone']).to eq('')
        expect(row['Director Department']).to eq('')
        expect(row['Change Description']).to eq('Do this, And that, Maybe more')
      end
    end
  end
end
