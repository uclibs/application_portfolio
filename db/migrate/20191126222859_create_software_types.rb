# frozen_string_literal: true

# Migration to create SoftwareTypes table
class CreateSoftwareTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :software_types do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
