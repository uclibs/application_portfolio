# frozen_string_literal: true

# SoftwareType Model
class SoftwareType < ApplicationRecord
  validates_presence_of :title, :description
  has_many :software_records
  has_many :request_softwares
end
