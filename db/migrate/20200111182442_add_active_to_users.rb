# frozen_string_literal: true

# Add active boolean field to Users table
class AddActiveToUsers < ActiveRecord::Migration[5.2]
  def self.up
    add_column :users, :active, :boolean, default: true, null: true
    add_index :users, :active
  end

  def self.down
    remove_index :users, :active
    remove_column :users, :active
  end
end
