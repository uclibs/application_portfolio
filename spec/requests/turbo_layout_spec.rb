# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Turbo layout integration', type: :request do
  before do
    sign_in FactoryBot.create(:admin)
  end

  it 'renders application layout with data-turbo-track assets' do
    get root_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include('data-turbo-track="reload"')
    expect(response.body).to match(%r{<script[^>]+src="[^"]*/turbo[^"]*"[^>]+type="module"})
    expect(response.body).not_to include('data-turbolinks-track')
    expect(response.body).not_to include('turbolinks')

    script_sources = response.body.scan(/<script[^>]+src="([^"]+)"/).flatten
    turbo_position = script_sources.index { |src| src.include?('/turbo') }
    application_position = script_sources.index { |src| src.include?('/application') }
    expect(turbo_position).to be_present
    expect(application_position).to be_present
    expect(turbo_position).to be < application_position
  end

  it 'renders software_records layout with data-turbo-track assets' do
    get software_records_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include('data-turbo-track="reload"')
    expect(response.body).to include('type="module"')
    expect(response.body).not_to include('data-turbolinks-track')
  end
end
