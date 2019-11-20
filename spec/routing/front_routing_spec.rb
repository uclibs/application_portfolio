# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :routing do
  describe 'routing' do
    it 'routes to /dashboard' do
      expect(get: '/dashboard').to route_to('front#index')
    end
  end
end
