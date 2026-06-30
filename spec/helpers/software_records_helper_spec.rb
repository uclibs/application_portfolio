# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SoftwareRecordsHelper, type: :helper do
  def helper_with_params(params)
    Object.new.tap do |object|
      object.extend(SoftwareRecordsHelper)
      object.define_singleton_method(:params) { params }
    end
  end

  describe '#pills' do
    {
      'In Design' => 'text-bg-dark',
      'In Development' => 'text-bg-info',
      'In Upgrade' => 'text-bg-warning',
      'Production' => 'text-bg-primary',
      'Available' => 'text-bg-success',
      'To be decomissioned' => 'text-bg-danger',
      'Something' => 'text-bg-light'
    }.each do |status, badge_class|
      it "renders #{badge_class} for #{status}" do
        expect(helper.pills(status)).to eq(%(<span class="badge rounded-pill #{badge_class}">#{status}</span>))
      end
    end
  end

  describe '#sort_column' do
    it 'returns the requested column when it exists on SoftwareRecord' do
      params = ActionController::Parameters.new(sort: 'title')

      expect(helper_with_params(params).sort_column).to eq('title')
    end

    it 'defaults to title when sort is not a SoftwareRecord column' do
      params = ActionController::Parameters.new(sort: 'not_a_column')

      expect(helper_with_params(params).sort_column).to eq('title')
    end
  end

  describe '#sort_direction' do
    it 'returns asc when direction is asc' do
      params = ActionController::Parameters.new(direction: 'asc')

      expect(helper_with_params(params).sort_direction).to eq('asc')
    end

    it 'returns desc when direction is desc' do
      params = ActionController::Parameters.new(direction: 'desc')

      expect(helper_with_params(params).sort_direction).to eq('desc')
    end

    it 'defaults to asc when direction is invalid' do
      params = ActionController::Parameters.new(direction: 'sideways')

      expect(helper_with_params(params).sort_direction).to eq('asc')
    end
  end

  describe '#encrypt' do
    it 'returns encrypted value' do
      expect(helper.encrypt('lets encrypt')).not_to eq('lets encrypt')
    end

    it 'coerces non-string values before encrypting' do
      encrypted = helper.encrypt(123)

      expect(helper.decrypt(encrypted)).to eq('123')
    end
  end

  describe '#decrypt' do
    it 'returns expected decrypt value' do
      encrypted = helper.encrypt('lets encrypt v2')
      expect(helper.decrypt(encrypted)).to eq('lets encrypt v2')
    end
  end

  describe '#vendor_piechart' do
    it 'returns vendor titles mapped to software record counts' do
      vendor = FactoryBot.create(:vendor_record, title: 'Acme Vendor')
      FactoryBot.create(:software_record, vendor_record: vendor)
      FactoryBot.create(:software_record, vendor_record: vendor)

      expect(helper.vendor_piechart).to eq('Acme Vendor' => 2)
    end
  end

  describe '#software_records_status_hash' do
    it 'returns status titles mapped to software record counts' do
      status = FactoryBot.create(:status, title: 'Production')
      FactoryBot.create(:software_record, status: status)

      expect(helper.software_records_status_hash).to eq('Production' => 1)
    end
  end

  describe '#yes_no_toggle' do
    it 'returns the raw attribute value from the software record' do
      software_record = FactoryBot.create(:software_record, track_uptime: true)
      helper.instance_variable_set(:@software_record, software_record)

      expect(helper.yes_no_toggle(:track_uptime)).to eq(software_record.read_attribute(:track_uptime))
    end
  end

  describe '#true_false_toggle' do
    it 'returns Yes when the attribute is true' do
      software_record = FactoryBot.create(:software_record, themes: true)
      helper.instance_variable_set(:@software_record, software_record)

      expect(helper.true_false_toggle(:themes)).to eq('Yes')
    end

    it 'returns No when the attribute is false' do
      software_record = FactoryBot.create(:software_record, modules: false)
      helper.instance_variable_set(:@software_record, software_record)

      expect(helper.true_false_toggle(:modules)).to eq('No')
    end
  end

  describe '#software_records_upgrade_hash' do
    it 'returns completed change requests for the software record' do
      software_record = FactoryBot.create(:software_record)
      completed = FactoryBot.create(:change_request, software_record: software_record, change_completed: true)
      FactoryBot.create(:change_request, software_record: software_record, change_completed: false)

      expect(helper.software_records_upgrade_hash(software_record.id)).to contain_exactly(completed)
    end
  end
end
