# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'change_requests/index.html.erb', type: :view do
  before(:each) do
    assign(:change_requests, [
             ChangeRequest.new(
               change_title: 'Change Request 1',
               change_description: 'Description 1',
               change_submitted_date: Date.today,
               change_completed: false,
               software_record_id: 1
             ),
             ChangeRequest.new(
               change_title: 'Change Request 2',
               change_description: 'Description 2',
               change_submitted_date: Date.today,
               change_completed: true,
               software_record_id: 2
             )
           ])
    assign(:change_request_counts, 2)
    admin = FactoryBot.create(:admin)
    sign_in(admin)
    assign(:current_user, double(role: 'root_admin'))
    render
  end
end
