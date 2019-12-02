# frozen_string_literal: true

# SoftwareRecord Model
class SoftwareRecord < ApplicationRecord
  STATUSES = ['None', 'In Design', 'In Development', 'Production', 'Available', 'To be decomissioned'].freeze

  validates_presence_of :title, :description, :status
end
