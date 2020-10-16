# frozen_string_literal: true

# SoftwareRecord Model
class SoftwareRecord < ActiveRecord::Base
  belongs_to :software_type
  belongs_to :vendor_record
  belongs_to :status
  validates_presence_of :title, :description, :status, :created_by
  serialize :tech_leads, Array
  serialize :developers, Array
  serialize :product_owners, Array
  serialize :departments, Array
end
