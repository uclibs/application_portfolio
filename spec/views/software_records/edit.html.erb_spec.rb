# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'software_records/edit', type: :view do
  before(:each) do
    allow(view).to(receive(:user_signed_in?) { true }) && allow(view).to(receive(:current_user) { FactoryBot.build(:admin) })
    VendorRecord.create!(
      title: 'Vendor 1',
      description: 'test vendor'
    )
    SoftwareType.create!(
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
    @software_record = assign(:software_record, SoftwareRecord.create!(
                                                  title: 'MyString',
                                                  description: 'MyText',
                                                  status_id: Status.first.id,
                                                  hosting_environment_id: HostingEnvironment.first.id,
                                                  software_type_id: SoftwareType.first.id,
                                                  vendor_record_id: VendorRecord.first.id,
                                                  created_by: 'Test User'
                                                ))
    session[:previous] = dashboard_path
  end

  it 'renders the edit software_record form' do
    render

    assert_select 'form[action=?][method=?]', software_record_path(@software_record), 'post' do
      assert_select 'input[name=?]', 'software_record[title]'
      assert_select 'textarea[name=?]', 'software_record[description]'
      assert_select 'select[name=?]', 'software_record[status_id]'
      assert_select 'select[name=?]', 'software_record[software_type_id]'
      assert_select 'select[name=?]', 'software_record[vendor_record_id]'
    end
  end

  it 'renders form tab links' do
    render

    assert_select 'form[action=?][method=?]', software_record_path(@software_record), 'post' do
      assert_select 'a#general-tab'
      assert_select 'a#server-environment-tab'
      assert_select 'a#change-management-tab'
      assert_select 'a#upgrade-history-tab'
    end
  end

  it 'renders the change management form' do
    render

    assert_select 'form[action=?][method=?]', software_record_path(@software_record), 'post' do
      assert_select 'input[name=?]', 'software_record[requires_cm]'
      assert_select 'input[name=?]', 'software_record[last_security_scan]'
      assert_select 'input[name=?]', 'software_record[last_ogc_review]'
      assert_select 'input[name=?]', 'software_record[last_accessibility_scan]'
      assert_select 'input[name=?]', 'software_record[last_info_sec_review]'
      assert_select 'textarea[name=?]', 'software_record[cm_other_notes]'
      assert_select 'textarea[name=?]', 'software_record[cm_stakeholders]'
    end
  end
end
