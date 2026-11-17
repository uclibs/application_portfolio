# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FileUploadsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:admin) { FactoryBot.create(:admin) }

  before { sign_in admin }

  describe 'GET #new' do
    it 'returns http success' do
      allow(controller).to receive(:render)
      get :new
      expect(response).to have_http_status(:success)
    end

    it 'sets the page title in the response' do
      get :new
      expect(response.body).to include('Import Seed Data | UCL Application Portfolio')
    end

    it 'assigns a new FileUpload as @file' do
      allow(controller).to receive(:render)
      get :new
      expect(assigns(:file)).to be_a(FileUpload)
      expect(assigns(:file)).to be_new_record
    end
  end

  describe 'POST #create' do
    let(:upload_dir) { Rails.root.join('public', 'uploads') }

    before { FileUtils.mkdir_p(upload_dir) }

    after do
      FileUtils.rm_f(upload_dir.join('software_records.csv'))
      FileUtils.rm_f(upload_dir.join('badname.csv'))
    end

    def upload_csv(filename)
      Rack::Test::UploadedFile.new(
        Rails.root.join('spec/fixtures/files/software_records.csv'),
        'text/csv',
        false,
        original_filename: filename
      )
    end

    {
      'srecords' => 'software',
      'vrecords' => 'vendor',
      'stypes' => 'type',
      'status' => 'status',
      'hosting_env' => 'hosting_env'
    }.each do |seed, kind|
      it "loads #{seed} through load_records.rb and removes the upload" do
        allow(controller).to receive(:system).and_return(true)

        post :create, params: {
          file_upload: { attachment: upload_csv('software_records.csv') },
          seed: seed
        }

        expect(controller).to have_received(:system).with('cd../..')
        expect(controller).to have_received(:system).with(
          'ruby', 'load_records.rb', kind, 'software_records.csv', 'Random Admin'
        )
        expect(response).to redirect_to(file_uploads_new_path)
        expect(flash[:notice]).to eq('The file `software_records.csv` has been loaded successfully.')
        expect(upload_dir.join('software_records.csv')).not_to exist
      end
    end

    it 'stores a sanitized filename and passes the original name to the importer' do
      allow(controller).to receive(:system).and_return(true)

      post :create, params: {
        file_upload: { attachment: upload_csv('bad name!.csv') },
        seed: 'srecords'
      }

      expect(controller).to have_received(:system).with(
        'ruby', 'load_records.rb', 'software', 'bad name!.csv', 'Random Admin'
      )
      expect(upload_dir.join('badname.csv')).not_to exist
    end

    it 'does not run the importer when the seed option is unknown' do
      allow(controller).to receive(:system).and_return(true)

      post :create, params: {
        file_upload: { attachment: upload_csv('software_records.csv') },
        seed: 'other'
      }

      expect(controller).not_to have_received(:system)
      expect(response).to redirect_to(file_uploads_new_path)
      expect(flash[:notice]).to eq('The file `software_records.csv` has been loaded successfully.')
    end

    it 'redirects to new with an error when no file is attached' do
      post :create, params: { file_upload: { name: 'No file' }, seed: 'srecords' }

      expect(response).to redirect_to(file_uploads_new_path)
      expect(flash[:error]).to eq('Cannot process seed data without input file.')
    end
  end
end
