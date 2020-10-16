# frozen_string_literal: true

# Rename column in software_records
class RenameColumnInSoftwareRecords < ActiveRecord::Migration[5.2]
  def change
    rename_column :software_records, :statuses_id, :status_id
  end
end
