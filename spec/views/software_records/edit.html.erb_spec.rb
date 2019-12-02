# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'software_records/edit', type: :view do
  before(:each) do
    @software_record = assign(:software_record, SoftwareRecord.create!(
                                                  title: 'MyString',
                                                  description: 'MyText',
                                                  status: 'MyString'
                                                ))
  end

  it 'renders the edit software_record form' do
    render

    assert_select 'form[action=?][method=?]', software_record_path(@software_record), 'post' do
      assert_select 'input[name=?]', 'software_record[title]'
      assert_select 'textarea[name=?]', 'software_record[description]'
      assert_select 'select[name=?]', 'software_record[status]'
    end
  end
end
