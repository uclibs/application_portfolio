# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Flash messages in responses', type: :request do
  let(:admin) { FactoryBot.create(:admin) }

  before { sign_in admin }

  it 'renders Bootstrap toast markup after a redirect with notice' do
    status = FactoryBot.create(:status, title: 'Active', status_type: 'Design')

    patch status_path(status), params: { status: { title: 'Updated', status_type: 'Design' } }

    follow_redirect!

    expect(response).to have_http_status(:ok)
    expect(response.body).to include('flash-toast-container')
    expect(response.body).to include('data-bs-delay="3000"')
    expect(response.body).to include('Status was successfully updated')
    expect(response.body).not_to include('gritter')
  end

  it 'renders a notice toast after create' do
    post statuses_path, params: { status: { title: 'New Status', status_type: 'Design' } }

    follow_redirect!

    expect(response).to have_http_status(:ok)
    expect(response.body).to include('flash-toast')
    expect(response.body).to include('Status was successfully created')
  end

  it 'renders a notice toast after destroy' do
    status = FactoryBot.create(:status, title: 'Retired', status_type: 'Design')

    delete status_path(status)

    follow_redirect!

    expect(response).to have_http_status(:ok)
    expect(response.body).to include('flash-toast')
    expect(response.body).to include('Status was successfully destroyed')
  end

  it 'renders Bootstrap form error alerts for invalid submissions' do
    status = FactoryBot.create(:status, title: 'Active', status_type: 'Design')

    patch status_path(status), params: { status: { title: '', status_type: '' } }

    expect(response).to have_http_status(:ok)
    expect(response.body).to include('id="error_explanation"')
    expect(response.body).to include('alert alert-danger')
    expect(response.body).to include("Title can't be blank")
    expect(response.body).not_to include('gritter')
  end

  it 'renders an error toast after a redirect with flash error' do
    post file_uploads_path, params: { file_upload: { name: 'No file' }, seed: 'srecords' }

    expect(response).to redirect_to(file_uploads_new_path)
    follow_redirect!

    expect(response.body).to include('flash-toast')
    expect(response.body).to include('Cannot process seed data without input file.')
  end
end
