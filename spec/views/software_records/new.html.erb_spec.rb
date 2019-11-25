# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'software_records/new', type: :view do
  before(:each) do
    assign(:software_record, SoftwareRecord.new(
                               title: 'MyString',
                               description: 'MyText',
                               status: 'MyString'
                             ))
  end

  it 'renders new software_record form' do
    render

    assert_select 'form[action=?][method=?]', software_records_path, 'post' do
      assert_select 'input[name=?]', 'software_record[title]'

      assert_select 'textarea[name=?]', 'software_record[description]'

      assert_select 'select[name=?]', 'software_record[status]'
    end
  end
end
