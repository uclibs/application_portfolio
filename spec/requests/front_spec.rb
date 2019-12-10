# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'FrontController', type: :request do
  def sign_in_user(user)
    sign_in user
  end

  before do
    user = FactoryBot.create(:user)
    sign_in_user(user)
  end

  describe 'GET /about' do
    it 'works! (now write some real specs)' do
      get about_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /welcome' do
    it 'works! (now write some real specs)' do
      get welcome_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /contact' do
    it 'works! (now write some real specs)' do
      get contact_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /dashboard' do
    it 'works! (now write some real specs)' do
      get dashboard_path
      expect(response).to have_http_status(200)
    end
  end
end
