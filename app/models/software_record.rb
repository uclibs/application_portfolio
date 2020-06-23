# frozen_string_literal: true

# SoftwareRecord Model
class SoftwareRecord < ApplicationRecord
  STATUSES = ['None', 'In Design', 'In Development', 'In Upgrade', 'Production', 'Available', 'To be decomissioned', 'Requested'].freeze
  belongs_to :software_type
  belongs_to :vendor_record
  validates_presence_of :title, :description, :status, :created_by
  serialize :tech_leads, Array
  serialize :developers, Array
  serialize :product_owners, Array
  serialize :departments, Array
end
