# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'SoftwareTypes', type: :request do
  def sign_in_user(admin)
    sign_in admin
  end

  before do
    admin = FactoryBot.create(:admin)
    sign_in_user(admin)
  end

  describe 'GET /software_types' do
    it 'requests /software_types' do
      get software_types_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /software_types/new' do
    it 'requests /software_types/new' do
      get new_software_type_path
      expect(response).to have_http_status(200)
    end
  end
end

RSpec.describe 'SoftwareTypes', type: :request do
  def sign_in_user(manager)
    sign_in manager
  end

  before do
    manager = FactoryBot.create(:manager)
    sign_in_user(manager)
  end

  describe 'GET /software_types' do
    it 'requests /software_types' do
      get software_types_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /software_types/new' do
    it 'requests /software_types/new' do
      get new_software_type_path
      expect(response).to have_http_status(200)
    end
  end
end

RSpec.describe 'SoftwareTypes', type: :request do
  def sign_in_user(viewer)
    sign_in viewer
  end

  before do
    viewer = FactoryBot.create(:viewer)
    sign_in_user(viewer)
  end

  describe 'GET /software_types' do
    it 'requests /software_types' do
      get software_types_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /software_records/new' do
    it 'requests /software_records/new' do
      get new_software_type_path
      expect(response).to_not have_http_status(200)
    end
  end
end

RSpec.describe 'SoftwareTypes', type: :request do
  def sign_in_user(owner)
    sign_in owner
  end

  before do
    owner = FactoryBot.create(:owner)
    sign_in_user(owner)
  end

  describe 'GET /software_types' do
    it 'requests /software_types' do
      get software_types_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /software_types/new' do
    it 'requests /software_types/new' do
      get new_software_type_path
      expect(response).to_not have_http_status(200)
    end
  end
end
