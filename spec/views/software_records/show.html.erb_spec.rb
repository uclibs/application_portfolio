# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'software_records/show', type: :view do
  before(:each) do
    VendorRecord.create!(
      title: 'Vendor 1',
      description: 'test vendor'
    )
    SoftwareType.create!(
      title: 'Web app',
      description: 'test software type'
    )
    @software_record = assign(:software_record, SoftwareRecord.create!(
                                                  title: 'MyString',
                                                  description: 'MyText',
                                                  status: 'MyString',
                                                  software_type_id: SoftwareType.first.id,
                                                  vendor_record_id: VendorRecord.first.id,
                                                  created_by: 'Test User'
                                                ))
    allow(view).to(receive(:user_signed_in?) { true }) && allow(view).to(receive(:current_user) { FactoryBot.build(:viewer) })
    session[:previous] = dashboard_path
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyString/)
  end
end
