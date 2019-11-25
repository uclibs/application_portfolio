# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'software_records/index', type: :view do
  before(:each) do
    assign(:software_records, [
             SoftwareRecord.create!(
               title: 'Title',
               description: 'MyText',
               status: 'Status'
             ),
             SoftwareRecord.create!(
               title: 'Title',
               description: 'MyText',
               status: 'Status'
             )
           ])
  end

  it 'renders a list of software_records' do
    render
    assert_select 'div>h3', text: 'Title'.to_s, count: 2
    assert_select 'div>em', text: 'MyText'.to_s, count: 2
    expect(rendered).to_not have_text('Status')
  end
end
