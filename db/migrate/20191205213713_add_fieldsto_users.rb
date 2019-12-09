# frozen_string_literal: true

# Add first_name, last_name for devise
class AddFieldstoUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
  end
end
