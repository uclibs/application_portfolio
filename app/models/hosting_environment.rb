# frozen_string_literal: true

# HostingEnvironment Model
class HostingEnvironment < ApplicationRecord
  validates_presence_of :title
  has_many :software_records
  has_many :request_softwares
end
