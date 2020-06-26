# frozen_string_literal: true

# Remove tentative_date_implemented column from software_records
class RemoveTentativeDateColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :software_records, :tentative_date_implemented, :date
  end
end
