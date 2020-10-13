# frozen_string_literal: true

# Create hosting_environments table
class CreateHostingEnvironments < ActiveRecord::Migration[5.2]
  def change
    create_table :hosting_environments do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
