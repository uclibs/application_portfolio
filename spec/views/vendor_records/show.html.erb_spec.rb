# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'vendor_records/show', type: :view do
  before(:each) do
    @vendor_record = assign(:vendor_record, VendorRecord.create!(
                                              title: 'Name',
                                              description: 'MyText'
                                            ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
  end
end
