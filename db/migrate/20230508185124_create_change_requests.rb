# frozen_string_literal: true

class CreateChangeRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :change_requests do |t|
      t.references :software_record, null: false, foreign_key: true

      t.string :change_title
      t.string :change_description
      t.date   :change_submitted_date
      t.boolean :change_completed, default: false

      t.date   :change_scheduled_date
      t.date   :change_completed_date

      t.string :manager_last_name
      t.string :manager_first_name
      t.string :manager_work_phone
      t.string :manager_contact_phone
      t.string :manager_department
      t.string :manager_email

      t.string :director_last_name
      t.string :director_first_name
      t.string :director_work_phone
      t.string :director_contact_phone
      t.string :director_department
      t.string :director_email

      t.timestamps
    end
  end
end
