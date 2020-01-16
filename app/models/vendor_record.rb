# frozen_string_literal: true

# VendorRecord Model
class VendorRecord < ApplicationRecord
  validates_presence_of :title, :description
  has_many :software_records
  has_many :request_softwares
end
