# frozen_string_literal: true

# FileUpload Model
class FileUpload < ApplicationRecord
  validates :attachment, presence: true
end
