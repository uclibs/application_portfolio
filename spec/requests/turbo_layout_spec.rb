# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Turbo layout integration', type: :request do
  before do
    sign_in FactoryBot.create(:admin)
  end

  it 'renders application layout with a single esbuild module bundle' do
    get root_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include('data-turbo-track="reload"')
    expect(response.body).not_to include('data-turbolinks-track')
    expect(response.body).not_to include('turbolinks')

    script_tags = response.body.scan(/<script[^>]*src="([^"]+)"[^>]*>/).flatten
    application_scripts = script_tags.select { |src| src.include?('/application') }

    expect(application_scripts.length).to eq(1)

    application_tag = response.body[%r{<script[^>]*src="[^"]*/application[^"]*"[^>]*>}]
    expect(application_tag).to include('type="module"')
    expect(application_tag).to include('defer')
    expect(script_tags).not_to include(a_string_matching(%r{/turbo\.}i))
    expect(script_tags).not_to include(a_string_matching(/jquery/i))
  end

  it 'renders software_records layout with a single esbuild module bundle' do
    get software_records_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include('data-turbo-track="reload"')
    expect(response.body).to include('type="module"')
    expect(response.body).to include('defer="defer"')
    expect(response.body).not_to include('data-turbolinks-track')

    script_tags = response.body.scan(/<script[^>]*src="([^"]+)"[^>]*>/).flatten
    expect(script_tags).not_to include(a_string_matching(%r{/turbo\.}i))
    expect(script_tags).not_to include(a_string_matching(/jquery/i))
  end

  it 'renders a Bootstrap click dropdown for the signed-in user menu' do
    get root_path

    expect(response.body).to include('data-bs-toggle="dropdown"')
    expect(response.body).to include('dropdown-menu')
    expect(response.body).to include('class="dropdown-item" href="/myprofile">My Profile')
    expect(response.body).not_to include('dropdown-content')
  end
end
