# frozen_string_literal: true

# SoftwareRecord Model
class SoftwareRecord < ApplicationRecord
  STATUSES = ['None', 'In Design', 'In Development', 'Production', 'Available', 'To be decomissioned'].freeze
  belongs_to :software_type
  belongs_to :vendor_record
  validates_presence_of :title, :description, :status
end
