# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ChangeRequests', type: :request do
  describe 'GET /change_requests' do
    context 'when signed in as an admin' do
      before { sign_in FactoryBot.create(:admin) }

      it 'returns a successful response' do
        get change_requests_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Change Requests')
      end

      it 'lists change requests with full management controls' do
        change_request = FactoryBot.create(:change_request, change_title: 'Deploy Auth Update')

        get change_requests_path

        expect(response.body).to include(change_request.change_title)
        expect(response.body).to include('Create a new change request')
        expect(response.body).to include('Delete')
      end
    end

    context 'when signed in as a viewer' do
      before { sign_in FactoryBot.create(:viewer) }

      it 'returns a successful response' do
        get change_requests_path

        expect(response).to have_http_status(:ok)
      end

      it 'shows view actions without create or delete controls' do
        FactoryBot.create(:change_request, change_title: 'Viewer Visible Request')

        get change_requests_path

        expect(response.body).to include('Viewer Visible Request')
        expect(response.body).not_to include('Create a new change request')
        expect(response.body).not_to include('Delete')
      end
    end

    context 'when signed in as a manager' do
      before { sign_in FactoryBot.create(:manager) }

      it 'shows create and edit controls without delete' do
        FactoryBot.create(:change_request)

        get change_requests_path

        expect(response.body).to include('Create a new change request')
        expect(response.body).to include('Edit')
        expect(response.body).not_to include('Delete')
      end
    end
  end

  describe 'GET /change_requests when unauthenticated' do
    it 'redirects to sign in' do
      get change_requests_path

      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
