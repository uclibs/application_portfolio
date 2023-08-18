# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ChangeRequestsHelper. For example:
#
# describe ChangeRequestsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ChangeRequestsHelper, type: :helper do
  describe '#sort_column' do
    it 'returns the sort column' do
      allow(helper).to receive(:params).and_return({ sort: 'title' })

      column = sort_column

      expect(column).to eq('title')
    end

    it 'returns the default sort column when sort param is not present' do
      allow(helper).to receive(:params).and_return({})

      column = sort_column

      expect(column).to eq('title')
    end
  end

  describe '#sort_direction' do
    it 'returns the sort direction' do
      allow(helper).to receive(:params).and_return({ direction: 'asc' })

      direction = sort_direction

      expect(direction).to eq('asc')
    end

    it 'returns the default sort direction when direction param is not present' do
      allow(helper).to receive(:params).and_return({})

      direction = sort_direction

      expect(direction).to eq('asc')
    end
  end

  describe '#find_software_name' do
    it 'returns the software name for the given id' do
      FactoryBot.create(:software_record, title: 'My Software', id: 1)

      name = find_software_name(1)

      expect(name).to eq('My Software')
    end
  end

  describe '#find_software_version' do
    it 'returns the software version for the given id' do
      FactoryBot.create(:software_record, current_version: '1.0', id: 1)

      version = find_software_version(1)

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
      FactoryBot.create(:software_record, tech_leads: %w[John Jane], id: 1)

      tech_leads = find_tech_leads(1)

      expect(tech_leads).to eq(%w[John Jane])
    end
  end
end
