# frozen_string_literal: true

# File Upload table migration
class CreateFileUploads < ActiveRecord::Migration[5.2]
  def change
    create_table :file_uploads do |t|
      t.string :attachment
      t.timestamps
    end
  end
end
