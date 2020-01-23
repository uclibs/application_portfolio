class AddSensitiveFieldstoSoftwareRecords < ActiveRecord::Migration[5.2]
  def change
  	add_column :software_records, :sensitive_information, :text
  end
end
