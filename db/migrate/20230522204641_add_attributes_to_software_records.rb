# frozen_string_literal: true

class AddAttributesToSoftwareRecords < ActiveRecord::Migration[6.1]
  def change
    add_column :software_records, :themes, :boolean
    add_column :software_records, :modules, :boolean
  end
end
