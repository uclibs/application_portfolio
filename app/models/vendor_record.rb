# frozen_string_literal: true

# VendorRecord Model
class VendorRecord < ApplicationRecord
  validates_presence_of :title, :description, :date_started
end
