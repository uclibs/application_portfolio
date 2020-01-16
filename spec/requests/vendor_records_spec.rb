# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VendorRecords', type: :request do
  def sign_in_user(admin)
    sign_in admin
  end

  before do
    admin = FactoryBot.create(:admin)
    sign_in_user(admin)
  end

  describe 'GET /vendor_records' do
    it 'requests /vendor_records' do
      get vendor_records_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /vendor_records/new' do
    it 'requests /vendor_records/new' do
      get new_vendor_record_path
      expect(response).to have_http_status(200)
    end
  end
end

RSpec.describe 'VendorRecords', type: :request do
  def sign_in_user(manager)
    sign_in manager
  end

  before do
    manager = FactoryBot.create(:manager)
    sign_in_user(manager)
  end

  describe 'GET /vendor_records' do
    it 'requests /vendor_records' do
      get vendor_records_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /vendor_records/new' do
    it 'requests /vendor_records/new' do
      get new_vendor_record_path
      expect(response).to have_http_status(200)
    end
  end
end

RSpec.describe 'VendorRecords', type: :request do
  def sign_in_user(viewer)
    sign_in viewer
  end

  before do
    viewer = FactoryBot.create(:viewer)
    sign_in_user(viewer)
  end

  describe 'GET /vendor_records' do
    it 'requests /vendor_records' do
      get vendor_records_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /vendor_records/new' do
    it 'requests /vendor_records/new' do
      get new_vendor_record_path
      expect(response).to_not have_http_status(200)
    end
  end
end

RSpec.describe 'VendorRecords', type: :request do
  def sign_in_user(owner)
    sign_in owner
  end

  before do
    owner = FactoryBot.create(:owner)
    sign_in_user(owner)
  end

  describe 'GET /vendor_records' do
    it 'requests /vendor_records' do
      get vendor_records_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /vendor_records/new' do
    it 'requests /vendor_records/new' do
      get new_vendor_record_path
      expect(response).to_not have_http_status(200)
    end
  end
end
