# frozen_string_literal: true

class AddMaintenanceToSoftwareRecords < ActiveRecord::Migration[5.2]
  def change
    add_column :software_records, :service, :string
    add_column :software_records, :installed_version, :string
    add_column :software_records, :latest_version, :string
    add_column :software_records, :proposed_version, :string
    add_column :software_records, :last_upgrade_date, :date
    add_column :software_records, :upgrade_available, :boolean
    add_column :software_records, :vulnerabilities_reported, :boolean
    add_column :software_records, :vulnerabilities_fixed, :boolean
    add_column :software_records, :bug_fixes, :boolean
    add_column :software_records, :new_features, :boolean
    add_column :software_records, :breaking_changes, :boolean
    add_column :software_records, :end_of_life, :boolean
    add_column :software_records, :priority, :integer
    add_column :software_records, :upgrade_status, :string
    add_column :software_records, :who, :string
    add_column :software_records, :when, :string
    add_column :software_records, :upgrade_docs, :string
  end
end
