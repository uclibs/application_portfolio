# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SoftwareTypesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/software_types').to route_to('software_types#index')
    end

    it 'routes to #new' do
      expect(get: '/software_types/new').to route_to('software_types#new')
    end

    it 'routes to #show' do
      expect(get: '/software_types/1').to route_to('software_types#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/software_types/1/edit').to route_to('software_types#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/software_types').to route_to('software_types#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/software_types/1').to route_to('software_types#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/software_types/1').to route_to('software_types#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/software_types/1').to route_to('software_types#destroy', id: '1')
    end
  end
end
