# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'SoftwareRecords', type: :request do
  def sign_in_user(admin)
    sign_in admin
  end

  before(:each) do
    admin = FactoryBot.create(:admin)
    sign_in_user(admin)
  end

  describe 'GET /software_records' do
    it 'requests /software_records' do
      get software_records_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /software_records/new' do
    it 'requests /software_records/new' do
      get new_software_record_path
      expect(response).to have_http_status(200)
    end
  end
end
