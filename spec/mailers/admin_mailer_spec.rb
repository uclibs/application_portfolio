# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdminMailer, type: :mailer do
  before(:each) do
    VendorRecord.create!(
      id: 41,
      title: 'Vendor 122',
      description: 'test vendor'
    )
    SoftwareType.create!(
      id: 211,
      title: 'Web app',
      description: 'test software type'
    )
  end
  describe 'new_software_request_mail' do
    let(:software_records) do
      SoftwareRecord.create!(
        title: 'Title',
        description: 'MyText',
        status: 'Status',
        date_implemented: '2020-12-12',
        vendor_record_id: VendorRecord.first.id,
        software_type_id: SoftwareType.first.id,
        created_by: 'Random Admin'
      )
    end
    it 'sends an email on new software request' do
      admin = FactoryBot.create(:admin)
      mail = described_class.new_software_request_mail(software_records.id, software_records.created_by).deliver_now
      expect(mail.subject).to eq('Software Requested for Application Portfolio')
      expect(mail.from).to eq(['uclappdev@uc.edu'])
      expect(mail.body.encoded).to match(admin.first_name + ' ' + admin.last_name)
      expect(mail.body.encoded).to match('Please find the link to the request below.')
    end
  end
end
