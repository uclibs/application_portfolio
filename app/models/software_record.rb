# frozen_string_literal: true

# SoftwareRecord Model
class SoftwareRecord < ApplicationRecord
  belongs_to :software_type
  belongs_to :vendor_record
  belongs_to :status
  belongs_to :hosting_environment
  has_many :change_request, dependent: :destroy
  validates :title, :description, :status, :created_by, presence: true
  serialize :tech_leads, type: Array, coder: YAML
  serialize :developers, type: Array, coder: YAML
  serialize :product_owners, type: Array, coder: YAML
  serialize :admin_users, type: Array, coder: YAML
  serialize :departments, type: Array, coder: YAML
end
