# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'vendor_records/index', type: :view do
  before(:each) do
    assign(:vendor_records, [
             VendorRecord.create!(
               title: 'Name',
               description: 'MyText',
               date_started: '07/11/1996'
             ),
             VendorRecord.create!(
               title: 'Name',
               description: 'MyText',
               date_started: '07/11/1996'
             )
           ])
  end

  it 'renders a list of vendor_records' do
    render
    assert_select 'div>h3', text: 'Name'.to_s, count: 2
    assert_select 'div>em', text: 'MyText'.to_s, count: 2
    expect(rendered).to_not have_text('Date Started')
  end
end
