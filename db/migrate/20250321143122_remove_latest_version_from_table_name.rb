# frozen_string_literal: true

class RemoveLatestVersionFromTableName < ActiveRecord::Migration[7.2]
  def change
    remove_column :software_records, :latest_version, :string
  end
end
