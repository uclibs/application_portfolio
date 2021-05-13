# frozen_string_literal: true

# VendorRecord Model
class VendorRecord < ApplicationRecord
  validates :title, :description, presence: true
  has_many :software_records
  has_many :request_softwares
end
