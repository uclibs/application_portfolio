# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShibbolethUserProvisioner, type: :service do
  describe '.find_or_create!' do
    let(:identity_attributes) do
      {
        eppn: 'viewer@uc.edu',
        email: 'viewer@uc.edu',
        first_name: 'Test',
        last_name: 'Viewer'
      }
    end

    def normalized(attributes)
      ShibbolethIdentityNormalizer.new(attributes).normalized
    end

    it 'returns existing users and preserves role' do
      user = FactoryBot.create(:admin, email: 'viewer@uc.edu')

      found_user = described_class.find_or_create!(normalized(identity_attributes))

      expect(found_user.id).to eq(user.id)
      expect(found_user.reload.role.to_s).to eq('root_admin')
    end

    it 'creates new users as active viewers' do
      created_user = described_class.find_or_create!(normalized(identity_attributes))

      expect(created_user.role.to_s).to eq('viewer')
      expect(created_user.active).to be(true)
    end

    it 'allows first-time users from non-uc domains' do
      created_user = described_class.find_or_create!(normalized(identity_attributes.merge(eppn: 'manager@example.com', email: 'manager@example.com')))

      expect(created_user.eppn).to eq('manager@example.com')
      expect(created_user.email).to eq('manager@example.com')
      expect(created_user.role.to_s).to eq('viewer')
    end

    it 'uses provided normalized identity when supplied' do
      normalized_identity = {
        eppn: 'normalized@uc.edu',
        email: 'normalized@uc.edu',
        first_name: 'Normalized',
        last_name: 'User'
      }

      created_user = described_class.find_or_create!(normalized_identity)

      expect(created_user.eppn).to eq('normalized@uc.edu')
      expect(created_user.email).to eq('normalized@uc.edu')
      expect(created_user.first_name).to eq('Normalized')
      expect(created_user.last_name).to eq('User')
    end

    it 'uses email as eppn fallback when eppn is blank' do
      created_user = described_class.find_or_create!(normalized(identity_attributes.merge(eppn: nil, email: 'jane.doe@example.com', first_name: 'Jane', last_name: 'Doe')))

      expect(created_user.eppn).to eq('jane.doe@example.com')
      expect(created_user.email).to eq('jane.doe@example.com')
    end

    it 'builds fallback eppn/email from names when identity values are blank' do
      created_user = described_class.find_or_create!(normalized(identity_attributes.merge(eppn: nil, email: nil, first_name: 'Jane', last_name: 'Doe')))

      expect(created_user.eppn).to eq('jane.doe@uc.edu')
      expect(created_user.email).to eq('jane.doe@uc.edu')
    end

    it 'uses blank-name fallbacks when creating fallback eppn/email' do
      created_user = described_class.find_or_create!(normalized(identity_attributes.merge(eppn: nil, email: nil, first_name: nil, last_name: '')))

      expect(created_user.first_name).to eq('BlankFirstName')
      expect(created_user.last_name).to eq('BlankLastName')
      expect(created_user.eppn).to eq('blankfirstname.blanklastname@uc.edu')
      expect(created_user.email).to eq('blankfirstname.blanklastname@uc.edu')
    end

    it 'treats null-like identity values as missing for eppn/email fallback' do
      created_user = described_class.find_or_create!(normalized(identity_attributes.merge(eppn: '(null)', email: '(null)', first_name: 'null', last_name: 'undefined')))

      expect(created_user.first_name).to eq('BlankFirstName')
      expect(created_user.last_name).to eq('BlankLastName')
      expect(created_user.eppn).to eq('blankfirstname.blanklastname@uc.edu')
      expect(created_user.email).to eq('blankfirstname.blanklastname@uc.edu')
    end

    it 'finds existing users by eppn even when email differs' do
      existing_user = FactoryBot.create(:viewer, eppn: 'manager@uc.edu', email: 'old@example.com')

      found_user = described_class.find_or_create!(normalized(identity_attributes.merge(eppn: 'manager@uc.edu', email: 'new@example.com')))

      expect(found_user.id).to eq(existing_user.id)
      expect(found_user.email).to eq('old@example.com')
    end

    it 'links legacy email-only users by assigning eppn on first shibboleth login' do
      existing_user = FactoryBot.create(:viewer, eppn: nil, email: 'legacy@example.com')

      found_user = described_class.find_or_create!(normalized(identity_attributes.merge(eppn: 'legacy@uc.edu', email: 'legacy@example.com')))

      expect(found_user.id).to eq(existing_user.id)
      expect(found_user.reload.eppn).to eq('legacy@uc.edu')
    end

    it 'raises a friendly error when email matches but eppn conflicts' do
      existing_user = FactoryBot.create(:viewer, eppn: 'old@uc.edu', email: 'legacy@example.com')

      expect do
        described_class.find_or_create!(normalized(identity_attributes.merge(eppn: 'new@uc.edu', email: 'legacy@example.com')))
      end.to raise_error(ShibbolethUserProvisioner::IdentityError, /identity conflict/)

      expect(existing_user.reload.eppn).to eq('old@uc.edu')
    end
  end
end
