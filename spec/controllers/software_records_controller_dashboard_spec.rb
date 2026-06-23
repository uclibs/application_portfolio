# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SoftwareRecordsController, type: :controller do
  include SoftwareRecordsControllerSpecHelpers

  describe '.indesign_dashboard' do
    it 'returns design-status records assigned to the user' do
      design_status = Status.find_by!(status_type: 'Design')
      matching = SoftwareRecord.create!(valid_attributes.merge(status_id: design_status.id))
      SoftwareRecord.create!(valid_attributes.merge(title: 'Other App', developers: ['Someone Else']))

      results = described_class.indesign_dashboard('Random Admin')

      expect(results).to include(matching)
      expect(results.pluck(:title)).not_to include('Other App')
    end
  end

  describe '.production_dashboard' do
    it 'returns production-status records assigned to the user' do
      production_status = Status.find_by!(status_type: 'Production')
      matching = SoftwareRecord.create!(valid_attributes.merge(status_id: production_status.id, developers: ['Random Admin']))
      SoftwareRecord.create!(valid_attributes.merge(title: 'Other Production', status_id: production_status.id, developers: ['Someone Else']))

      results = described_class.production_dashboard('Random Admin')

      expect(results).to include(matching)
      expect(results.pluck(:title)).not_to include('Other Production')
    end
  end

  describe '.inchange_dashboard' do
    it 'returns in-progress change records assigned to the user' do
      software_record = SoftwareRecord.create!(valid_attributes)
      ChangeRequest.create!(
        change_title: 'Pending change',
        change_description: 'Details',
        software_record_id: software_record.id,
        application_pages: 1,
        number_roles: 1,
        authentication_needed: true,
        custom_error_pages: true,
        change_completed: false
      )
      SoftwareRecord.create!(valid_attributes.merge(title: 'No Change Request', developers: ['Someone Else']))

      results = described_class.inchange_dashboard('Random Admin')

      expect(results).to include(software_record)
      expect(results.pluck(:title)).not_to include('No Change Request')
    end
  end
end
