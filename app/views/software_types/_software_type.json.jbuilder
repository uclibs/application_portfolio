# frozen_string_literal: true

json.extract! software_type, :id, :title, :description, :created_at, :updated_at
json.url software_type_url(software_type, format: :json)
