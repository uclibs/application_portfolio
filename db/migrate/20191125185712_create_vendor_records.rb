# frozen_string_literal: true

# Migration to create vendor_records table
class CreateVendorRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :vendor_records do |t|
      t.string :name
      t.text :description
      t.date :date_started

      t.timestamps
    end
  end
end
