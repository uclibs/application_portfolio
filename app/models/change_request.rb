# frozen_string_literal: true

class ChangeRequest < ApplicationRecord
  validates :change_title, presence: true
  validates :application_pages, presence: true
  validates :number_roles, presence: true
  validates :authentication_needed, presence: true
  validates :custom_error_pages, presence: true
  belongs_to :software_record
end
