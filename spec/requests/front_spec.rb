# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'FrontController', type: :request do
  before do
    sign_in FactoryBot.create(:admin)
  end

  describe 'GET /about' do
    it 'requests about page' do
      get about_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /contact' do
    it 'requests contact page' do
      get contact_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /dashboard' do
    it 'requests dashboard page with chartkick chart markup' do
      get dashboard_path

      expect(response).to have_http_status(200)
      expect(response.body.scan(/id="chart-\d+"/).size).to be >= 4
    end
  end

  describe 'GET /profile' do
    it 'requests profile page' do
      get myprofile_path

      expect(response).to have_http_status(200)
      expect(response.body).to include('nav-profile')
    end
  end
end
