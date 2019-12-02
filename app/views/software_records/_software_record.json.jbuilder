# frozen_string_literal: true

json.extract! software_record, :id, :title, :description, :status, :created_at, :updated_at
json.url software_record_url(software_record, format: :json)
