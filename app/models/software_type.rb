# frozen_string_literal: true

# SoftwareType Model
class SoftwareType < ApplicationRecord
  validates :title, :description, presence: true
  has_many :software_records
  has_many :request_softwares
end
