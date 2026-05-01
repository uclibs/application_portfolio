# frozen_string_literal: true

class AddEppnToUsers < ActiveRecord::Migration[7.2]
  class MigrationUser < ApplicationRecord
    self.table_name = 'users'
  end

  def up
    add_column :users, :eppn, :string

    MigrationUser.reset_column_information
    MigrationUser.where(eppn: [nil, '']).find_each do |user|
      normalized_eppn = user.email.to_s.strip.downcase
      next if normalized_eppn.blank?

      user.update_columns(eppn: normalized_eppn)
    end

    add_index :users, :eppn, unique: true
  end

  def down
    remove_index :users, :eppn
    remove_column :users, :eppn
  end
end
