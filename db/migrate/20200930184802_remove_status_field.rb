# frozen_string_literal: true

# Remove column in software_records
class RemoveStatusField < ActiveRecord::Migration[5.2]
  def change
    remove_column :software_records, :status, :string
  end
end
