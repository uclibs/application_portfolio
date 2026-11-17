# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SoftwareTypesHelper, type: :helper do
  def helper_with_params(params)
    Object.new.tap do |object|
      object.extend(SoftwareTypesHelper)
      object.define_singleton_method(:params) { params }
    end
  end

  describe '#sort_column' do
    it 'returns the requested column when it exists on SoftwareType' do
      params = ActionController::Parameters.new(sort: 'description')

      expect(helper_with_params(params).sort_column).to eq('description')
    end

    it 'defaults to title when sort is missing or not a SoftwareType column' do
      missing = ActionController::Parameters.new
      invalid = ActionController::Parameters.new(sort: 'not_a_column')

      expect(helper_with_params(missing).sort_column).to eq('title')
      expect(helper_with_params(invalid).sort_column).to eq('title')
    end
  end

  describe '#sort_direction' do
    it 'returns asc or desc when the direction is one of those values' do
      ascending = ActionController::Parameters.new(direction: 'asc')
      descending = ActionController::Parameters.new(direction: 'desc')

      expect(helper_with_params(ascending).sort_direction).to eq('asc')
      expect(helper_with_params(descending).sort_direction).to eq('desc')
    end

    it 'defaults to asc when direction is missing or invalid' do
      missing = ActionController::Parameters.new
      invalid = ActionController::Parameters.new(direction: 'sideways')

      expect(helper_with_params(missing).sort_direction).to eq('asc')
      expect(helper_with_params(invalid).sort_direction).to eq('asc')
    end
  end
end
