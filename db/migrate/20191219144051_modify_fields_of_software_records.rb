# frozen_string_literal: true

# Modify SoftwareRecord column_types
class ModifyFieldsOfSoftwareRecords < ActiveRecord::Migration[5.2]
  def change
    change_column :software_records, :user_seats, :string
    change_column :software_records, :current_version, :string
  end
end
