# frozen_string_literal: true

# Add foreign key of status to software_records table
class AddReferenceOfStatusToSoftwareRecords < ActiveRecord::Migration[5.2]
  def change
    add_reference :software_records, :statuses, foreign_key: true
  end
end
