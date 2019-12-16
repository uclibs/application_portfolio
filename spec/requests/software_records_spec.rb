# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'SoftwareRecords', type: :request do
  def sign_in_user(user)
    sign_in user
  end

  before do
    user = FactoryBot.create(:user)
    sign_in_user(user)
  end

  describe 'GET /software_records' do
    it 'requests /software_records' do
      get software_records_path
      expect(response).to have_http_status(200)
    end
  end
end
