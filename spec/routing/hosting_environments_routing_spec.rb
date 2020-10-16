# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HostingEnvironmentsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/hosting_environments').to route_to('hosting_environments#index')
    end

    it 'routes to #new' do
      expect(get: '/hosting_environments/new').to route_to('hosting_environments#new')
    end

    it 'routes to #show' do
      expect(get: '/hosting_environments/1').to route_to('hosting_environments#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/hosting_environments/1/edit').to route_to('hosting_environments#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/hosting_environments').to route_to('hosting_environments#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/hosting_environments/1').to route_to('hosting_environments#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/hosting_environments/1').to route_to('hosting_environments#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/hosting_environments/1').to route_to('hosting_environments#destroy', id: '1')
    end
  end
end
