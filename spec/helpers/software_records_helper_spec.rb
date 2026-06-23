# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SoftwareRecordsHelper, type: :helper do
  describe '#pills' do
    it 'renders Bootstrap 5 status badges' do
      expect(helper.pills('In Design')).to eq('<span class="badge rounded-pill text-bg-dark">In Design</span>')
      expect(helper.pills('In Development')).to eq('<span class="badge rounded-pill text-bg-info">In Development</span>')
      expect(helper.pills('Production')).to eq('<span class="badge rounded-pill text-bg-primary">Production</span>')
      expect(helper.pills('Available')).to eq('<span class="badge rounded-pill text-bg-success">Available</span>')
      expect(helper.pills('To be decomissioned')).to eq('<span class="badge rounded-pill text-bg-danger">To be decomissioned</span>')
      expect(helper.pills('Something')).to eq('<span class="badge rounded-pill text-bg-light">Something</span>')
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
