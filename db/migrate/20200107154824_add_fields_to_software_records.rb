# frozen_string_literal: true

# Add fields to SoftwareRecords table
class AddFieldsToSoftwareRecords < ActiveRecord::Migration[5.2]
  def change
    add_column :software_records, :tentative_date_implemented, :date
    add_column :software_records, :created_by, :string
  end
end
