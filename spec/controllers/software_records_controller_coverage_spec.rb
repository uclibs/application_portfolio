# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SoftwareRecordsController, type: :controller do
  include SoftwareRecordsControllerSpecHelpers

  describe 'GET #list_upgrades' do
    it 'returns maintenance records with default sorting' do
      SoftwareRecord.create!(valid_attributes)

      get :list_upgrades

      expect(response).to be_successful
      expect(assigns(:software_records)).to be_present
    end

    it 'filters by software type' do
      SoftwareRecord.create!(valid_attributes)

      get :list_upgrades, params: { filter_by: 'software_types', software_type_filter: SoftwareType.first.id }

      expect(response).to be_successful
      expect(assigns(:software_records).pluck(:software_type_id)).to all(eq(SoftwareType.first.id))
    end

    it 'filters by vendor record' do
      SoftwareRecord.create!(valid_attributes)

      get :list_upgrades, params: { filter_by: 'vendor_records', vendor_record_filter: VendorRecord.first.id }

      expect(response).to be_successful
      expect(assigns(:software_records).pluck(:vendor_record_id)).to all(eq(VendorRecord.first.id))
    end

    it 'uses priority sort helpers for invalid sort params' do
      SoftwareRecord.create!(valid_attributes)

      get :list_upgrades, params: { sort: 'not_a_column', direction: 'sideways' }

      expect(response).to be_successful
    end
  end

  describe 'GET #list_decommissioned' do
    it 'filters decommissioned records by software type' do
      SoftwareRecord.create!(decommissioned_attributes)

      get :list_decommissioned, params: { filter_by: 'software_types', software_type_filter: SoftwareType.first.id }

      expect(response).to be_successful
      expect(assigns(:software_records)).to be_a(ActiveRecord::Relation)
    end

    it 'filters decommissioned records by vendor record' do
      SoftwareRecord.create!(decommissioned_attributes)

      get :list_decommissioned, params: { filter_by: 'vendor_records', vendor_record_filter: VendorRecord.first.id }

      expect(response).to be_successful
      expect(assigns(:software_records)).to be_a(ActiveRecord::Relation)
    end
  end

  describe 'GET #index' do
    it 'falls back to default sort params when values are invalid' do
      SoftwareRecord.create!(valid_attributes)

      get :index, params: { sort: 'not_a_column', direction: 'sideways' }

      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'decrypts sensitive information when present' do
      encrypted = controller.check_and_encrypt('classified')
      software_record = SoftwareRecord.create!(valid_attributes.merge(sensitive_information: encrypted))

      get :show, params: { id: software_record.to_param }

      expect(response).to be_successful
      expect(assigns(:decrypted_sensitive_information)).to eq('classified')
    end
  end

  describe 'POST #create as guest' do
    before { sign_out :user }

    it 'creates a record and sends mail when reCaptcha passes' do
      mailer = instance_double(ActionMailer::MessageDelivery, deliver_now: true)
      allow(controller).to receive(:verify_recaptcha).and_return(true)
      allow(AdminMailer).to receive(:new_software_request_mail).and_return(mailer)

      expect do
        post :create, params: { software_record: valid_attributes }
      end.to change(SoftwareRecord, :count).by(1)

      expect(response).to redirect_to(SoftwareRecord.last)
      expect(flash[:notice]).to eq('Software record was successfully requested.')
    end

    it 'redirects with an error when reCaptcha fails' do
      allow(controller).to receive(:verify_recaptcha).and_return(false)

      expect do
        post :create, params: { software_record: valid_attributes }
      end.to change(SoftwareRecord, :count).by(1)

      expect(response).to redirect_to(request_new_path)
      expect(flash[:error]).to eq('reCaptcha not verified. Please try again and verify reCaptcha.')
    end

    it 'redirects with an error when validation fails' do
      post :create, params: { software_record: invalid_attributes }

      expect(response).to redirect_to(request_new_path)
      expect(flash[:error]).to eq('All mandatory fields are required.')
    end
  end

  describe 'PATCH #update_road_map' do
    it 'renders edit_road_map when update fails' do
      software_record = SoftwareRecord.create!(valid_attributes)
      allow_any_instance_of(SoftwareRecord).to receive(:update).and_return(false)

      patch :update_road_map, params: { id: software_record.id, software_record: { road_map: 'Blocked update' } }

      expect(response).to render_template(:edit_road_map)
    end
  end

  describe '#check_and_encrypt' do
    it 'encrypts present values' do
      encrypted = controller.check_and_encrypt('secret')

      expect(encrypted).to include('$$')
    end

    it 'returns nil for blank values' do
      expect(controller.check_and_encrypt('')).to be_nil
      expect(controller.check_and_encrypt(nil)).to be_nil
    end
  end

  describe '#check_and_decrypt' do
    it 'decrypts present values' do
      encrypted = controller.check_and_encrypt('secret')

      expect(controller.check_and_decrypt(encrypted)).to eq('secret')
    end

    it 'returns nil for blank values' do
      expect(controller.check_and_decrypt('')).to be_nil
      expect(controller.check_and_decrypt(nil)).to be_nil
    end
  end
end
