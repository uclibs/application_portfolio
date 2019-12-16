# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'vendor_records/edit', type: :view do
  before(:each) do
    @vendor_record = assign(:vendor_record, VendorRecord.create!(
                                              title: 'MyString',
                                              description: 'MyText'
                                            ))
  end

  it 'renders the edit vendor_record form' do
    render

    assert_select 'form[action=?][method=?]', vendor_record_path(@vendor_record), 'post' do
      assert_select 'input[name=?]', 'vendor_record[title]'
      assert_select 'textarea[name=?]', 'vendor_record[description]'
    end
  end
end
