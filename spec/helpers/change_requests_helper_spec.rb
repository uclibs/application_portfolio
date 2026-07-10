# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChangeRequestsHelper, type: :helper do
  describe '#find_software_name' do
    it 'returns the software name for the given id' do
      software_record = FactoryBot.create(:software_record, title: 'My Software')

      name = find_software_name(software_record.id)

      expect(name).to eq('My Software')
    end
  end

  describe '#find_software_version' do
    it 'returns the software version for the given id' do
      software_record = FactoryBot.create(:software_record, current_version: '1.0')

      version = find_software_version(software_record.id)

      expect(version).to eq('1.0')
    end
  end

  describe '#convert_completed' do
    it "returns 'Completed' when value is true" do
      label = convert_completed(true)

      expect(label).to eq('Completed')
    end

    it "returns 'Active' when value is false" do
      label = convert_completed(false)

      expect(label).to eq('Active')
    end
  end

  describe '#find_tech_leads' do
    it 'returns the tech leads for the given software record id' do
      software_record = FactoryBot.create(:software_record, tech_leads: %w[John Jane])

      tech_leads = find_tech_leads(software_record.id)

      expect(tech_leads).to eq(%w[John Jane])
    end
  end

  describe '#software_records_where_hash' do
    it 'returns change requests for the given software record id' do
      software_record = FactoryBot.create(:software_record)
      change_request = FactoryBot.create(:change_request, software_record: software_record)

      results = software_records_where_hash(software_record.id)

      expect(results).to include(change_request)
    end
  end
end
