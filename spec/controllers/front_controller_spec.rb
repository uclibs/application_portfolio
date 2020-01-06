# frozen_string_literal: true

require 'rails_helper'

describe FrontController do
  include Devise::Test::ControllerHelpers
  render_views

  describe '#index' do
    it 'renders the index page' do
      get :index
      expect(response.status).to eq(200)
      expect(response).to render_template('index')
    end
  end

  describe '#about' do
    it 'renders the about page' do
      get :about
      expect(response.status).to eq(200)
      expect(response).to render_template('about')
    end
  end

  describe '#contact' do
    it 'renders the contact page' do
      get :contact
      expect(response.status).to eq(200)
      expect(response).to render_template('contact')
    end
  end

  describe '#dashboard' do
    def sign_in_user(user)
      sign_in user
    end

    before do
      user = FactoryBot.create(:user)
      sign_in_user(user)
    end

    it 'renders the dashboard page' do
      get :dashboard
      expect(response.status).to eq(200)
      expect(response).to render_template('dashboard')
    end
  end

  describe '#profile' do
    def sign_in_user(user)
      sign_in user
    end

    before do
      user = FactoryBot.create(:user)
      sign_in_user(user)
    end

    it 'renders the profile page' do
      get :profile
      expect(response.status).to eq(200)
      expect(response).to render_template('profile')
    end
  end
end
