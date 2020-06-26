# frozen_string_literal: true

# Add source_code_url for software_records table.
class AddSourceCodeUrl < ActiveRecord::Migration[5.2]
  def change
    add_column :software_records, :source_code_url, :text
  end
end
