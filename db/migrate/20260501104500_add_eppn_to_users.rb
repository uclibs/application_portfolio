# frozen_string_literal: true

class AddEppnToUsers < ActiveRecord::Migration[7.2]
  def up
    add_column :users, :eppn, :string

    add_index :users, :eppn, unique: true
  end

  def down
    remove_index :users, :eppn
    remove_column :users, :eppn
  end
end
