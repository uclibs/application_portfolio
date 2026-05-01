# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '.find_or_create_for_shibboleth!' do
    let(:identity_attributes) do
      {
        eppn: 'viewer@uc.edu',
        email: 'viewer@uc.edu',
        first_name: 'Test',
        last_name: 'Viewer'
      }
    end

    it 'returns existing users and preserves role' do
      user = FactoryBot.create(:admin, email: 'viewer@uc.edu')

      found_user = User.find_or_create_for_shibboleth!(identity_attributes)

      expect(found_user.id).to eq(user.id)
      expect(found_user.reload.role.to_s).to eq('root_admin')
    end

    it 'creates new users as active viewers' do
      allow_any_instance_of(User).to receive(:send_admin_mail).and_return(true)

      created_user = User.find_or_create_for_shibboleth!(identity_attributes)

      expect(created_user.role.to_s).to eq('viewer')
      expect(created_user.active).to be(true)
    end

    it 'allows first-time users from non-uc domains' do
      allow_any_instance_of(User).to receive(:send_admin_mail).and_return(true)

      created_user = User.find_or_create_for_shibboleth!(
        identity_attributes.merge(eppn: 'manager@example.com', email: 'manager@example.com')
      )

      expect(created_user.eppn).to eq('manager@example.com')
      expect(created_user.email).to eq('manager@example.com')
      expect(created_user.role.to_s).to eq('viewer')
    end

    it 'builds fallback eppn/email from names when identity values are blank' do
      allow_any_instance_of(User).to receive(:send_admin_mail).and_return(true)

      created_user = User.find_or_create_for_shibboleth!(
        identity_attributes.merge(eppn: nil, email: nil, first_name: 'Jane', last_name: 'Doe')
      )

      expect(created_user.eppn).to eq('jane.doe@uc.edu')
      expect(created_user.email).to eq('jane.doe@uc.edu')
    end

    it 'uses blank-name fallbacks when creating fallback eppn/email' do
      allow_any_instance_of(User).to receive(:send_admin_mail).and_return(true)

      created_user = User.find_or_create_for_shibboleth!(
        identity_attributes.merge(eppn: nil, email: nil, first_name: nil, last_name: '')
      )

      expect(created_user.first_name).to eq('BlankFirstName')
      expect(created_user.last_name).to eq('BlankLastName')
      expect(created_user.eppn).to eq('blankfirstname.blanklastname@uc.edu')
      expect(created_user.email).to eq('blankfirstname.blanklastname@uc.edu')
    end

    it 'treats null-like identity values as missing for eppn/email fallback' do
      allow_any_instance_of(User).to receive(:send_admin_mail).and_return(true)

      created_user = User.find_or_create_for_shibboleth!(
        identity_attributes.merge(eppn: '(null)', email: '(null)', first_name: 'null', last_name: 'undefined')
      )

      expect(created_user.first_name).to eq('BlankFirstName')
      expect(created_user.last_name).to eq('BlankLastName')
      expect(created_user.eppn).to eq('blankfirstname.blanklastname@uc.edu')
      expect(created_user.email).to eq('blankfirstname.blanklastname@uc.edu')
    end

    it 'finds existing users by eppn even when email differs' do
      existing_user = FactoryBot.create(:viewer, eppn: 'manager@uc.edu', email: 'old@example.com')

      found_user = User.find_or_create_for_shibboleth!(
        identity_attributes.merge(eppn: 'manager@uc.edu', email: 'new@example.com')
      )

      expect(found_user.id).to eq(existing_user.id)
      expect(found_user.email).to eq('old@example.com')
    end
  end
end
