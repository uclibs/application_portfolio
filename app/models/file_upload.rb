# frozen_string_literal: true

# FileUpload Model
class FileUpload < ApplicationRecord
  validates_presence_of :attachment
end
