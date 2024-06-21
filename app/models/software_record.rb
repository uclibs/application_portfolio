# frozen_string_literal: true

# SoftwareRecord Model
class SoftwareRecord < ApplicationRecord
  belongs_to :software_type
  belongs_to :vendor_record
  belongs_to :status
  belongs_to :hosting_environment
  has_many :change_request, dependent: :destroy
  validates :title, :description, :status, :created_by, presence: true
  serialize :tech_leads, Array
  serialize :developers, Array
  serialize :product_owners, Array
  serialize :admin_users, Array
  serialize :departments, Array
end
