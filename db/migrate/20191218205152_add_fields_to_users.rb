# frozen_string_literal: true

# Add fields to User Model
class AddFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :department, :string
    add_column :users, :title, :string
  end
end
