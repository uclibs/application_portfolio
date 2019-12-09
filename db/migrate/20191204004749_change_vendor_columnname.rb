# frozen_string_literal: true

# Change vendor_records column name
class ChangeVendorColumnname < ActiveRecord::Migration[5.2]
  def change
    rename_column :vendor_records, :name, :title
  end
end
