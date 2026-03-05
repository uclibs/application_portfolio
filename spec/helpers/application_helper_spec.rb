# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'generate_software_records_series' do
    let(:status) { FactoryBot.create(:status) }
    let(:hosting_environment) { FactoryBot.create(:hosting_environment) }
    let(:software_type) { FactoryBot.create(:software_type) }
    let(:vendor_record) { FactoryBot.create(:vendor_record) }
    let!(:software_record) { FactoryBot.create(:software_record, vendor_record_id: vendor_record.id, software_type_id: software_type.id, status_id: status.id, hosting_environment_id: hosting_environment.id) }
    let!(:software_record_old) { FactoryBot.create(:software_record, created_at: '1968-01-01', vendor_record_id: vendor_record.id, software_type_id: software_type.id, status_id: status.id, hosting_environment_id: hosting_environment.id) }

    it 'returns a monotonically increasing series with a non-zero initial value' do
      graph_values = generate_software_records_series
      values = graph_values[0][:data].values

      expect(values.first).to be > 0
      expect(values).to eq(values.sort)
    end
  end
end
