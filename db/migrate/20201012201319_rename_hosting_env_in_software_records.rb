# frozen_string_literal: true

# Rename column in software_records
class RenameHostingEnvInSoftwareRecords < ActiveRecord::Migration[5.2]
  def change
    rename_column :software_records, :hosting_environments_id, :hosting_environment_id
  end
end
