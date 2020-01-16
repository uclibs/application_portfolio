# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'software_records/index', type: :view do
  before(:each) do
    assign(:software_records, [
             VendorRecord.create!(
               title: 'Vendor 1',
               description: 'test vendor'
             ),
             SoftwareType.create!(
               title: 'Web app',
               description: 'test software type'
             ),
             SoftwareRecord.create!(
               title: 'Title',
               description: 'MyText',
               status: 'Status',
               vendor_record_id: VendorRecord.first.id,
               software_type_id: SoftwareType.first.id,
               created_by: 'Test User'
             ),
             SoftwareRecord.create!(
               title: 'Title',
               description: 'MyText',
               status: 'Status',
               vendor_record_id: VendorRecord.first.id,
               software_type_id: SoftwareType.first.id,
               created_by: 'Test User'
             )
           ])
    allow(view).to(receive(:user_signed_in?) { true }) && allow(view).to(receive(:current_user) { FactoryBot.build(:admin) })
  end

  it 'renders a list of software_records' do
    render
    assert_select 'td:nth-child(1)', text: 'Title'.to_s, count: 2
    expect(rendered).to_not have_text('Status')
  end
end
