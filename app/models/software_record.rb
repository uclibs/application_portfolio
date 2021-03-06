# frozen_string_literal: true

# SoftwareRecord Model
class SoftwareRecord < ApplicationRecord
  belongs_to :software_type
  belongs_to :vendor_record
  belongs_to :status
  belongs_to :hosting_environment
  validates :title, :description, :status, :created_by, presence: true
  serialize :tech_leads, Array
  serialize :developers, Array
  serialize :product_owners, Array
  serialize :departments, Array
end
