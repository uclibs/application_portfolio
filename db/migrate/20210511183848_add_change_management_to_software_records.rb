# frozen_string_literal: true

class AddChangeManagementToSoftwareRecords < ActiveRecord::Migration[5.2]
  def change
    add_column :software_records, :requires_cm, :string
    add_column :software_records, :last_security_scan, :date
    add_column :software_records, :last_accessibility_scan, :date
    add_column :software_records, :last_ogc_review, :date
    add_column :software_records, :last_info_sec_review, :date
    add_column :software_records, :cm_stakeholders, :text
    add_column :software_records, :cm_other_notes, :text
  end
end
