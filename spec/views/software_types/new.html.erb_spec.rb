# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'software_types/new', type: :view do
  before(:each) do
    assign(:software_type, SoftwareType.new(
                             title: 'MyString',
                             description: 'MyText'
                           ))
  end

  it 'renders new software_type form' do
    render

    assert_select 'form[action=?][method=?]', software_types_path, 'post' do
      assert_select 'input[name=?]', 'software_type[title]'

      assert_select 'textarea[name=?]', 'software_type[description]'
    end
  end
end
