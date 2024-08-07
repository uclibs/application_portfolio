# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SoftwareRecordsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/software_records').to route_to('software_records#index')
    end

    it 'routes to #new' do
      expect(get: '/software_records/new').to route_to('software_records#new')
    end

    it 'routes to #show' do
      expect(get: '/software_records/1').to route_to('software_records#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/software_records/1/edit').to route_to('software_records#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/software_records').to route_to('software_records#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/software_records/1').to route_to('software_records#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/software_records/1').to route_to('software_records#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/software_records/1').to route_to('software_records#destroy', id: '1')
    end

    it 'routes to #list_upgrades' do
      expect(get: '/list_upgrades').to route_to('software_records#list_upgrades')
    end

    it 'routes to #list_decommissioned' do
      expect(get: '/list_decommissioned').to route_to('software_records#list_decommissioned')
    end

    it 'routes to #list_road_map' do
      expect(get: '/list_road_map').to route_to('software_records#list_road_map')
    end
  end
end
