# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'software_types/show', type: :view do
  before(:each) do
    @software_type = assign(:software_type, SoftwareType.create!(
                                              title: 'Title',
                                              description: 'MyText'
                                            ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
  end
end
