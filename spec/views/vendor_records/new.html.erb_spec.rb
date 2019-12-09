# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'vendor_records/new', type: :view do
  before(:each) do
    assign(:vendor_record, VendorRecord.new(
                             title: 'MyString',
                             description: 'MyText',
                             date_started: '07/11/1996'
                           ))
  end

  it 'renders new vendor_record form' do
    render
    assert_select 'form[action=?][method=?]', vendor_records_path, 'post' do
      assert_select 'input[name=?]', 'vendor_record[title]'
      assert_select 'textarea[name=?]', 'vendor_record[description]'
      assert_select 'input[name=?]', 'vendor_record[date_started]'
    end
  end
end
