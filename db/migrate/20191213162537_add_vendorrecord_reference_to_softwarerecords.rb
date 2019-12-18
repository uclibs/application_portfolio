# frozen_string_literal: true

# Add foreign key of vendor_records table to software_records table
class AddVendorrecordReferenceToSoftwarerecords < ActiveRecord::Migration[5.2]
  def change
    add_reference :software_records, :vendor_record, foreign_key: true
  end
end
