# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FileUploadsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:admin) { FactoryBot.create(:admin) }

  before { sign_in admin }

  describe 'GET #new' do
    before { allow(controller).to receive(:render) } # avoid layout/asset pipeline in controller spec

    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end

    it 'sets the page title' do
      get :new
      expect($page_title).to eq('Import Seed Data | UCL Application Portfolio')
    end

    it 'assigns a new FileUpload as @file' do
      get :new
      expect(assigns(:file)).to be_a(FileUpload)
      expect(assigns(:file)).to be_new_record
    end
  end

  describe 'POST #create' do
    context 'when create raises StandardError (e.g. no attachment)' do
      it 'redirects to new with error flash' do
        post :create, params: { file_upload: { name: 'No file' }, seed: 'srecords' }
        expect(response).to redirect_to(file_uploads_new_path)
        expect(flash[:error]).to eq('Cannot process seed data without input file.')
      end
    end
  end
end
