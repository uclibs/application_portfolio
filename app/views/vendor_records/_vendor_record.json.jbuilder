# frozen_string_literal: true

json.extract! vendor_record, :id, :name, :description, :date_started, :created_at, :updated_at
json.url vendor_record_url(vendor_record, format: :json)
