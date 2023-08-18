# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'change_requests/edit.html.erb', type: :view do
  before(:each) do
    @change_request = assign(:change_request, ChangeRequest.new(
                                                change_title: 'Change Request Title',
                                                change_description: 'Change Request Description',
                                                change_submitted_date: Date.today,
                                                change_completed: false,
                                                software_record_id: 1,
                                                change_scheduled_date: Date.today + 1.day,
                                                change_completed_date: nil,
                                                manager_last_name: 'Smith',
                                                manager_first_name: 'John',
                                                manager_work_phone: '1234567890',
                                                manager_contact_phone: '0987654321',
                                                manager_department: 'IT',
                                                manager_email: 'john@example.com',
                                                director_last_name: 'Doe',
                                                director_first_name: 'Jane',
                                                director_work_phone: '9876543210',
                                                director_contact_phone: '0123456789',
                                                director_department: 'Management',
                                                director_email: 'jane@example.com',
                                                application_pages: 10,
                                                number_roles: 5,
                                                authentication_needed: true,
                                                custom_error_pages: true
                                              ))
  end
end
