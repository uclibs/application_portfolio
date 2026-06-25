# frozen_string_literal: true

module LookupTableRecords
  def lookup_table_records
    @lookup_table_records ||= {
      vendor_record: VendorRecord.create!(title: 'Vendor 1', description: 'test vendor'),
      software_type: SoftwareType.create!(title: 'Web app', description: 'test software type'),
      status: Status.create!(title: 'Test', status_type: 'Design'),
      hosting_environment: HostingEnvironment.create!(title: 'Test Env.', description: 'test env.')
    }
  end

  def software_record_attributes(**overrides)
    tables = lookup_table_records

    {
      title: 'Scholar UC',
      description: 'UC Digital conservatory preservation library',
      status_id: tables.fetch(:status).id,
      hosting_environment_id: tables.fetch(:hosting_environment).id,
      software_type_id: tables.fetch(:software_type).id,
      vendor_record_id: tables.fetch(:vendor_record).id,
      created_by: 'Test User',
      **overrides
    }
  end

  def build_software_record(**overrides)
    SoftwareRecord.new(software_record_attributes(**overrides))
  end
end

RSpec.configure do |config|
  config.include LookupTableRecords, type: :model
end
