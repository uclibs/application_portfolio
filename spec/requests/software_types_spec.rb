# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'SoftwareTypes', type: :request do
  def sign_in_user(user)
    sign_in user
  end

  before do
    user = FactoryBot.create(:user)
    sign_in_user(user)
  end
  describe 'GET /software_types' do
    it 'works! (now write some real specs)' do
      get software_types_path
      expect(response).to have_http_status(200)
    end
  end
end
