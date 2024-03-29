# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'software_records/new', type: :view do
  before(:each) do
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
    allow(view).to(receive(:user_signed_in?) { true }) && allow(view).to(receive(:current_user) do
                                                                           FactoryBot.build(:admin)
                                                                         end)
    @software_record = assign(:software_record, SoftwareRecord.new(
                                                  title: 'MyString',
                                                  description: 'MyText',
                                                  status_id: Status.first.id,
                                                  hosting_environment_id: HostingEnvironment.first.id,
                                                  software_type_id: SoftwareType.first.id,
                                                  vendor_record_id: VendorRecord.first.id,
                                                  created_by: 'Test User',
                                                  themes: true,
                                                  modules: true
                                                ))
  end

  it 'renders new software_record form' do
    render

    expect(rendered).to have_select('software_record_authentication_type', with_options: %w[DUO LDAP E-Directory Shibboleth Local])

    assert_select 'form[action=?][method=?]', software_records_path, 'post' do
      assert_select 'input[name=?]', 'software_record[title]'

      assert_select 'textarea[name=?]', 'software_record[description]'

      assert_select 'select[name=?]', 'software_record[status_id]'
      assert_select 'select[name=?]', 'software_record[software_type_id]'
      assert_select 'select[name=?]', 'software_record[vendor_record_id]'
      assert_select 'input[name=?]', 'software_record[themes]'
      assert_select 'input[name=?]', 'software_record[modules]'
    end
  end
end
