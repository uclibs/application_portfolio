# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VendorRecordsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/vendor_records').to route_to('vendor_records#index')
    end

    it 'routes to #new' do
      expect(get: '/vendor_records/new').to route_to('vendor_records#new')
    end

    it 'routes to #show' do
      expect(get: '/vendor_records/1').to route_to('vendor_records#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/vendor_records/1/edit').to route_to('vendor_records#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/vendor_records').to route_to('vendor_records#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/vendor_records/1').to route_to('vendor_records#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/vendor_records/1').to route_to('vendor_records#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/vendor_records/1').to route_to('vendor_records#destroy', id: '1')
    end
  end
end
