# frozen_string_literal: true

# Remove date_started column from vendor_records table
class RemoveDatestartedFromVendorrecords < ActiveRecord::Migration[5.2]
  def change
    remove_column :vendor_records, :date_started, :date
  end
end
