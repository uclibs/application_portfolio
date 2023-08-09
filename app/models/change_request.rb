# frozen_string_literal: true

class ChangeRequest < ApplicationRecord
  validates :change_title, presence: true
  belongs_to :software_record
end
