# frozen_string_literal: true

# Add foreign key of software_type table to software_records table
class AddSoftwaretypeReferenceToSoftwarerecords < ActiveRecord::Migration[5.2]
  def change
    add_reference :software_records, :software_type, foreign_key: true
  end
end
