# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '.find_or_create_for_shibboleth!' do
    let(:identity_attributes) do
      {
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

    it 'allows first-time users from qamail.uc.edu' do
      allow_any_instance_of(User).to receive(:send_admin_mail).and_return(true)

      created_user = User.find_or_create_for_shibboleth!(
        identity_attributes.merge(email: 'manager@qamail.uc.edu')
      )

      expect(created_user.email).to eq('manager@qamail.uc.edu')
      expect(created_user.role.to_s).to eq('viewer')
    end

    it 'raises when required identity data is missing' do
      expect do
        User.find_or_create_for_shibboleth!(identity_attributes.merge(first_name: ''))
      end.to raise_error(User::ShibbolethIdentityError)
    end
  end
end
