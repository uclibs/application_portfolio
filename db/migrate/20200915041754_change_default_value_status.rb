# frozen_string_literal: true

# Change default value on Statuses table
class ChangeDefaultValueStatus < ActiveRecord::Migration[5.2]
  def up
    change_column :statuses, :status_type, :string, default: 'Other'
  end

  def down
    change_column :statuses, :status_type, :string, default: nil
  end
end
