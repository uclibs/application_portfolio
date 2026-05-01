# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  include Devise::Test::ControllerHelpers

  controller(ApplicationController) do
    def index
      render plain: 'ok'
    end

    def edit
      render plain: 'edit'
    end
  end

  before do
    routes.draw do
      get 'index' => 'anonymous#index'
      get 'dashboard' => 'anonymous#index', as: :dashboard
      get 'users/:id/edit' => 'anonymous#edit', as: :user_edit
    end

    allow(Rails.configuration.x.auth).to receive(:shibboleth_enabled).and_return(true)
  end

  it 'redirects users with first-login flag and incomplete profile' do
    user = FactoryBot.create(:viewer, department: nil, title: nil)
    sign_in user
    session[:require_profile_completion] = true

    get :index

    expect(response).to redirect_to(user_edit_path(user.id, return_to: dashboard_path))
    expect(session[:require_profile_completion]).to be_nil
  end

  it 'does not redirect existing users without first-login flag' do
    user = FactoryBot.create(:viewer, department: nil, title: nil)
    sign_in user

    get :index

    expect(response).to have_http_status(:ok)
  end

  it 'clears first-login flag once profile is complete' do
    user = FactoryBot.create(:viewer, department: 'Libraries', title: 'Analyst')
    sign_in user
    session[:require_profile_completion] = true

    get :index

    expect(response).to have_http_status(:ok)
    expect(session[:require_profile_completion]).to be_nil
  end
end
