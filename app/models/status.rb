# frozen_string_literal: true

# Status Model
class Status < ApplicationRecord
  validates :title, presence: true
  has_many :software_records
  has_many :request_softwares
end
