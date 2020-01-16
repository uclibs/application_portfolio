# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'FrontController', type: :request do
  def sign_in_user(admin)
    sign_in admin
  end

  before do
    admin = FactoryBot.create(:admin)
    sign_in_user(admin)
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
    it 'requests dashboard page' do
      get dashboard_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /profile' do
    it 'requests profile page' do
      get dashboard_path
      expect(response).to have_http_status(200)
    end
  end
end
