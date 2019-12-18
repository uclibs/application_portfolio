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
    @software_record = assign(:software_record, SoftwareRecord.new(
                                                  title: 'MyString',
                                                  description: 'MyText',
                                                  status: 'MyString',
                                                  software_type_id: SoftwareType.first.id,
                                                  vendor_record_id: VendorRecord.first.id
                                                ))
  end

  it 'renders new software_record form' do
    render

    assert_select 'form[action=?][method=?]', software_records_path, 'post' do
      assert_select 'input[name=?]', 'software_record[title]'

      assert_select 'textarea[name=?]', 'software_record[description]'

      assert_select 'select[name=?]', 'software_record[status]'
      assert_select 'select[name=?]', 'software_record[software_type_id]'
      assert_select 'select[name=?]', 'software_record[vendor_record_id]'
    end
  end
end
