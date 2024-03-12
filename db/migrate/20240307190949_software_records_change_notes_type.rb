# frozen_string_literal: true

class SoftwareRecordsChangeNotesType < ActiveRecord::Migration[6.1]
  def change
    change_column :software_records, :notes, :text
  end
end
