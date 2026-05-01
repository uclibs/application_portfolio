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

    it 'allows first-time users from non-uc domains' do
      allow_any_instance_of(User).to receive(:send_admin_mail).and_return(true)

      created_user = User.find_or_create_for_shibboleth!(
        identity_attributes.merge(email: 'manager@example.com')
      )

      expect(created_user.email).to eq('manager@example.com')
      expect(created_user.role.to_s).to eq('viewer')
    end

    it 'builds a uc email from names when email is blank' do
      allow_any_instance_of(User).to receive(:send_admin_mail).and_return(true)

      created_user = User.find_or_create_for_shibboleth!(
        identity_attributes.merge(email: nil, first_name: 'Jane', last_name: 'Doe')
      )

      expect(created_user.email).to eq('jane.doe@uc.edu')
    end

    it 'uses blank-name fallbacks when creating a fallback email' do
      allow_any_instance_of(User).to receive(:send_admin_mail).and_return(true)

      created_user = User.find_or_create_for_shibboleth!(
        identity_attributes.merge(email: nil, first_name: nil, last_name: '')
      )

      expect(created_user.first_name).to eq('BlankFirstName')
      expect(created_user.last_name).to eq('BlankLastName')
      expect(created_user.email).to eq('blankfirstname.blanklastname@uc.edu')
    end
  end
end
