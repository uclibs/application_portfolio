# frozen_string_literal: true

# Add default value to roles column as viewer
class ChangeRolesColumn < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :roles, :string, default: 'viewer'
  end
end
