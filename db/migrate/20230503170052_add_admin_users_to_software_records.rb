# frozen_string_literal: true

class AddAdminUsersToSoftwareRecords < ActiveRecord::Migration[6.1]
  def change
    add_column :software_records, :admin_users, :text
  end
end
