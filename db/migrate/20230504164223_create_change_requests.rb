class CreateChangeRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :change_requests do |t|
      t.references :software_record, null: false, foreign_key: true

      t.timestamps
    end
  end
end
