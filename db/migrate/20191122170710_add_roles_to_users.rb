# frozen_string_literal: true

# Add roles column to users table
class AddRolesToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :roles, :string
  end
end
