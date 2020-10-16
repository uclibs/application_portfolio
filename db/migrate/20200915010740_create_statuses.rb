# frozen_string_literal: true

# Create status table
class CreateStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :statuses do |t|
      t.string :title
      t.string :status_type

      t.timestamps
    end
  end
end
