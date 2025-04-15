# frozen_string_literal: true

class ChangeDescriptionTypeInChangeRequests < ActiveRecord::Migration[7.2]
  def change
    change_column :change_requests, :change_description, :text
  end
end
