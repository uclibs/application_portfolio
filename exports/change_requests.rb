# frozen_string_literal: true

# !/usr/bin/env ruby
require 'csv'
require "#{Dir.pwd}/config/environment.rb"

# Export ChangeRequests Data
class ChangeRequest
  def export
    file = "#{Dir.pwd}/public/change_requests.csv"
    change_requests = ChangeRequest
                      .joins(:software_record)
                      .joins('JOIN statuses ON software_records.status_id = statuses.id')
                      .where.not(statuses: { status_type: 'Decommissioned' })

    headers = [
      'Software Record Title', 'Change Title', 'Change Description', 'Submitted Date',
      'Completed?', 'Scheduled Date', 'Completed Date',
      'Manager First Name', 'Manager Last Name', 'Manager Work Phone',
      'Manager Contact Phone', 'Manager Department', 'Manager Email',
      'Director First Name', 'Director Last Name', 'Director Work Phone',
      'Director Contact Phone', 'Director Department', 'Director Email',
      'Application Pages', 'Number of Roles', 'Authentication Needed?',
      'Custom Error Pages?', 'Created At', 'Updated At'
    ]

    CSV.open(file, 'w', write_headers: true, headers:) do |writer|
      change_requests.each do |cr|
        writer << [
          cr.software_record&.title, cr.change_title,
          clean_and_format(cr.change_description), cr.change_submitted_date,
          cr.change_completed, cr.change_scheduled_date, cr.change_completed_date,
          cr.manager_first_name, cr.manager_last_name, cr.manager_work_phone,
          cr.manager_contact_phone, cr.manager_department, cr.manager_email,
          cr.director_first_name, cr.director_last_name, cr.director_work_phone,
          cr.director_contact_phone, cr.director_department, cr.director_email,
          cr.application_pages, cr.number_roles, cr.authentication_needed,
          cr.custom_error_pages, cr.created_at, cr.updated_at
        ]
      end
    end
  end

  private

  def clean_and_format(attribute)
    formatted_attribute = attribute.to_s.gsub('---', '').gsub("\n", '-')
    parts = formatted_attribute.split('- ').reject { |part| part == '-' }
    parts.map { |part| part.gsub('-', '').strip }.join(', ')
  end
end

ChangeRequest.new.export
