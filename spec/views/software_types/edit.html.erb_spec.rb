# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'software_types/edit', type: :view do
  before(:each) do
    @software_type = assign(:software_type, SoftwareType.create!(
                                              title: 'MyString',
                                              description: 'MyText'
                                            ))
  end

  it 'renders the edit software_type form' do
    render

    assert_select 'form[action=?][method=?]', software_type_path(@software_type), 'post' do
      assert_select 'input[name=?]', 'software_type[title]'

      assert_select 'textarea[name=?]', 'software_type[description]'
    end
  end
end
