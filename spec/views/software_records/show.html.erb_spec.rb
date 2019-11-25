# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'software_records/show', type: :view do
  before(:each) do
    @software_record = assign(:software_record, SoftwareRecord.create!(
                                                  title: 'Title',
                                                  description: 'MyText',
                                                  status: 'Status'
                                                ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Status/)
  end
end
