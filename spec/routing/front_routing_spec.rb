# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :routing do
  describe 'routing' do
    it 'routes to /about' do
      expect(get: '/about').to route_to('front#about')
    end
    it 'routes to /contact' do
      expect(get: '/contact').to route_to('front#contact')
    end
    it 'routes to /dashboard' do
      expect(get: '/dashboard').to route_to('front#dashboard')
    end
    it 'routes to /myprofile' do
      expect(get: '/myprofile').to route_to('front#profile')
    end
  end
end
