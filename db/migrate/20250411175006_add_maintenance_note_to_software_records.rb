# frozen_string_literal: true

class AddMaintenanceNoteToSoftwareRecords < ActiveRecord::Migration[7.2]
  def change
    add_column :software_records, :maintenance_note, :text
  end
end
