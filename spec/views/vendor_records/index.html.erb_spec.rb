# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'vendor_records/index', type: :view do
  before(:each) do
    assign(:vendor_records, [
             VendorRecord.create!(
               title: 'Name',
               description: 'MyText'
             ),
             VendorRecord.create!(
               title: 'Name',
               description: 'MyText'
             )
           ])
  end

  it 'renders a list of vendor_records' do
    render
    assert_select 'td:nth-child(1)', text: 'Name'.to_s, count: 2
  end
end
