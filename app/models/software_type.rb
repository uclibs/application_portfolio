# frozen_string_literal: true

# SoftwareType Model
class SoftwareType < ApplicationRecord
  validates_presence_of :title, :description
end
