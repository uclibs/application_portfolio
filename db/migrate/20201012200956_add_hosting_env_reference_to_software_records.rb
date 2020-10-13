# frozen_string_literal: true

# Add foreign key of hosting_environments to software_records table
class AddHostingEnvReferenceToSoftwareRecords < ActiveRecord::Migration[5.2]
  def change
    add_reference :software_records, :hosting_environments, foreign_key: true
  end
end
