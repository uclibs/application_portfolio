# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'change_requests/new.html.erb', type: :view do
  before(:each) do
    assign(:change_request, ChangeRequest.new)
    render
  end

  it 'renders the new change request form' do
    assert_select 'form[action=?][method=?]', change_requests_path, 'post' do
      assert_select 'input[name=?]', 'change_request[change_title]'
      assert_select 'textarea[name=?]', 'change_request[change_description]'
      assert_select 'input[name=?]', 'change_request[change_submitted_date]'
      assert_select 'input[type=?]', 'checkbox', count: 3
      assert_select 'input[name=?]', 'change_request[application_pages]'
      assert_select 'input[name=?]', 'change_request[number_roles]'
      assert_select 'input[type=?]', 'submit'
    end
  end
end
