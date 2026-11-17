# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VendorRecordsHelper, type: :helper do
  def helper_with_params(params)
    helper.define_singleton_method(:params) { params }
    # The helper spec has no current route. Keep link_to real and turn its options into a path.
    helper.define_singleton_method(:url_for) do |options|
      query = options.map { |key, value| "#{key}=#{value}" }.join('&')
      "/vendor_records?#{query}"
    end
    helper
  end

  describe '#sortable' do
    it 'uses the given label and flips an ascending sort to descending' do
      params = ActionController::Parameters.new(sort: 'title', direction: 'asc')
      html = helper_with_params(params).sortable('title', 'Vendors')

      expect(html).to include('>Vendors<')
      expect(html).to include('sort=title')
      expect(html).to include('direction=desc')
      expect(html).to include('class="th-link"')
      expect(html).not_to include('class=th-link')
    end

    it 'flips a descending sort back to ascending' do
      params = ActionController::Parameters.new(sort: 'title', direction: 'desc')
      html = helper_with_params(params).sortable('title', 'Vendors')

      expect(html).to include('direction=asc')
    end

    it 'titleizes the column and does not flip direction for a different column' do
      params = ActionController::Parameters.new(sort: 'title', direction: 'asc')
      html = helper_with_params(params).sortable('description')

      expect(html).to include('Description')
      expect(html).to include('sort=description')
      expect(html).to include('direction=false')
    end
  end

  describe '#sort_column' do
    it 'returns the requested column when it exists on VendorRecord' do
      params = ActionController::Parameters.new(sort: 'description')

      expect(helper_with_params(params).sort_column).to eq('description')
    end

    it 'defaults to title when sort is missing or not a VendorRecord column' do
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
