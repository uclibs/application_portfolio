# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create default vendor records
vendor_records = { 'Adobe': 'Adobe systems',
                   'AP Trust': 'Ap Trust',
                   'ArchiveSpace': 'Archive space',
                   'Atlas Solution': 'Atlas Solution',
                   'Open Source': 'Non-profit volunteer team' }

vendor_records.each do |name, desc|
  VendorRecord.create(title: name, description: desc)
end

# Create default hosting env records
hosting_env = { 'None': 'Not currently hosted',
                'Adobe': 'Adobe systems',
                'Kaltura': 'Kaltura video services',
                'Local': 'Hosted by Libraries or UCit',
                'OhioLink': 'Hosted by Ohiolink.edu' }

hosting_env.each do |name, desc|
  HostingEnvironment.create(title: name, description: desc)
end

# Create default status types
status = { 'Available': 'Production',
           'Development': 'Design',
           'Production': 'Production',
           'Decommissioned': 'Decommissioned' }

status.each do |name, desc|
  Status.create(title: name, status_type: desc)
end

# Create default software types
software_types = { 'Backend': 'Software without direct public interface',
                   'Cloud': 'Software hosted on someone elses computer',
                   'Client / Server': 'API service, etc',
                   'Desktop': 'Standalone software to run on personal machines',
                   'Web App': 'An application publicly accessed on the world wide web' }

software_types.each do |name, desc|
  SoftwareType.create(title: name, description: desc)
end

# Create test user and skip email validation
test_user = User.new(first_name: 'Test', last_name: 'User', email: 'testuser1@example.com')
test_user.save(validate: false)

# Create Software record

SoftwareRecord.create!(title: 'test', software_type: SoftwareType.find(1), vendor_record: VendorRecord.find(1), status: Status.find(1), hosting_environment: HostingEnvironment.first, description: 'test', created_by: 'test_user')
