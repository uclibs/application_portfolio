# frozen_string_literal: true

# Migration for updating url to production_url in software_records table.
class UpdateUrl < ActiveRecord::Migration[5.2]
  def change
    rename_column :software_records, :url, :production_url
  end
end
