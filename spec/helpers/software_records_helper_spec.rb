# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SoftwareRecordsHelper, type: :helper do
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

  describe '#encrypt' do
    it 'returns encrypted value' do
      expect(helper.encrypt('lets encrypt')).not_to eq('lets encrypt')
    end
  end

  describe '#decrypt' do
    it 'returns expected decrypt value' do
      encrypted = helper.encrypt('lets encrypt v2')
      expect(helper.decrypt(encrypted)).to eq('lets encrypt v2')
    end
  end
end
