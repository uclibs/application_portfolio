# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FileUploadsController, type: :controller do
  include Devise::Test::ControllerHelpers
  render_views

  before do
    admin = FactoryBot.create(:admin)
    sign_in_user(admin)
  end

  def sign_in_user(admin)
    sign_in admin
  end

  describe 'GET #new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #create' do
    it 'returns http success' do
      get :create
      expect(response).to redirect_to %r{http://test.host/seed/new}
    end
  end
end
