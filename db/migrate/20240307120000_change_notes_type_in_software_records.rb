class ChangeNotesTypeInSoftwareRecord < ActiveRecord::Migration[6.0]
  def change
    change_column :software_records, :notes, :text
  end
end

