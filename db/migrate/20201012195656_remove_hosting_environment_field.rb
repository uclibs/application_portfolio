# frozen_string_literal: true

# Remove hosting_environment column from software_records
class RemoveHostingEnvironmentField < ActiveRecord::Migration[5.2]
  def change
    remove_column :software_records, :hosting_environment, :string
  end
end
