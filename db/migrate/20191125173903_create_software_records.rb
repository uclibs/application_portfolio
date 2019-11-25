# frozen_string_literal: true

# Migration to create software_records table
class CreateSoftwareRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :software_records do |t|
      t.string :title
      t.text :description
      t.string :status

      t.timestamps
    end
  end
end
