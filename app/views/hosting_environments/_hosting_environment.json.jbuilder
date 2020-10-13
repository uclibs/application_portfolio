# frozen_string_literal: true

json.extract! hosting_environment, :id, :title, :description, :created_at, :updated_at
json.url hosting_environment_url(hosting_environment, format: :json)
