# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'HostingEnvironments', type: :request do
  def sign_in_user(admin)
    sign_in admin
  end

  before do
    admin = FactoryBot.create(:admin)
    sign_in_user(admin)
  end
  describe 'GET /hosting_environments' do
    it 'requests /hosting_environments' do
      get hosting_environments_path
      expect(response).to have_http_status(200)
    end
  end
end
