# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExportDataController, type: :controller do
  include Devise::Test::ControllerHelpers
  render_views

  before do
    admin = FactoryBot.create(:admin)
    sign_in_user(admin)
  end

  def sign_in_user(admin)
    sign_in admin
  end

  describe 'GET #software_records' do
    it 'returns http success' do
      get :software_records
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #vendor_records' do
    it 'returns http success' do
      get :vendor_records
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #software_types' do
    it 'returns http success' do
      get :software_types
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #change_requests' do
    it 'returns http success' do
      get :change_requests
      expect(response).to have_http_status(:success)
    end
  end
end
