# frozen_string_literal: true

class AddAuthenticationToSoftwareRecords < ActiveRecord::Migration[5.2]
  def change
    add_column :software_records, :authentication_type, :string
  end
end
