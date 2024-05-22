class AddRoadmapReferenceToSoftwareRecords < ActiveRecord::Migration[6.1]
  def change
    add_column :software_records, :road_map, :text
  end
end
