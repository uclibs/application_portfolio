# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'software_records/index', type: :view do
  before(:each) do
    VendorRecord.create!(
      id: 311,
      title: 'Vendor 122',
      description: 'test vendor'
    )
    VendorRecord.create!(
      id: 411,
      title: 'Vendor Filter',
      description: 'test filter vendor'
    )
    SoftwareType.create!(
      id: 111,
      title: 'Web app',
      description: 'test software type'
    )
    Status.create!(
      title: 'Test',
      status_type: 'Design'
    )
    HostingEnvironment.create!(
      title: 'Test Env.',
      description: 'test env.'
    )
    assign(:software_records, [
             SoftwareRecord.create!(
               title: 'Title',
               description: 'MyText',
               status_id: Status.first.id,
               hosting_environment_id: HostingEnvironment.first.id,
               date_implemented: '2020-12-12',
               vendor_record_id: VendorRecord.first.id,
               software_type_id: SoftwareType.first.id,
               created_by: 'Test User'
             ),
             SoftwareRecord.create!(
               title: 'Title',
               description: 'MyText',
               status_id: Status.first.id,
               hosting_environment_id: HostingEnvironment.first.id,
               date_implemented: '2020-12-12',
               vendor_record_id: VendorRecord.first.id,
               software_type_id: SoftwareType.first.id,
               created_by: 'Test User'
             )
           ])
    assign(:vendor_records, VendorRecord.all)
    assign(:software_types, SoftwareType.all)

    allow(view).to(receive(:user_signed_in?) { true }) && allow(view).to(receive(:current_user) do
                                                                           FactoryBot.build(:admin)
                                                                         end)
  end
  it 'renders a list of software_records' do
    render
    assert_select 'td:nth-child(1)', text: 'Title'.to_s, count: 2
    expect(rendered).to_not have_text('Status')
  end

  it 'renders the expected list when filter is applied' do
    render
    expect(rendered).to have_text('Vendor Filter')
  end
end
