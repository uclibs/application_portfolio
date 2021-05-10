# frozen_string_literal: true

# HostingEnvironment Model
class HostingEnvironment < ApplicationRecord
  validates :title, presence: true
  has_many :software_records
  has_many :request_softwares
end
