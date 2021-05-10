# frozen_string_literal: true

# !/bin/env ruby
require 'csv'
require "#{Dir.pwd}/config/environment.rb"

# Export SoftwareType Data
class SoftwareTypes < ApplicationRecord
  def software_types
    file = "#{Dir.pwd}/public/software_types.csv"
    software_types = SoftwareType.all

    headers = ['SoftwareType ID', 'Created On', 'Software Type', 'Description']

    CSV.open(file, 'w', write_headers: true, headers: headers) do |writer|
      software_types.each do |software_type|
        writer << [software_type.id, software_type.created_at, software_type.title,
                   software_type.description]
      end
    end
  end
end

type = SoftwareTypes.new
type.software_types
