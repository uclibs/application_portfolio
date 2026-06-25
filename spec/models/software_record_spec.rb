# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SoftwareRecord, type: :model do
  describe 'validations' do
    it 'is valid with required attributes' do
      expect(build_software_record).to be_valid
    end

    %i[title description created_by].each do |attribute|
      it "is invalid without #{attribute}" do
        record = build_software_record(attribute => nil)

        expect(record).not_to be_valid
        expect(record.errors[attribute]).to include("can't be blank")
      end
    end

    it 'is invalid without status' do
      record = build_software_record(status: nil, status_id: nil)

      expect(record).not_to be_valid
      expect(record.errors[:status]).to include("can't be blank")
    end

    %i[software_type vendor_record hosting_environment].each do |association|
      it "is invalid without #{association}" do
        expect(build_software_record("#{association}_id": nil)).not_to be_valid
      end
    end
  end

  describe 'serialized array attributes' do
    it 'round-trips YAML-serialized arrays' do
      serialized_values = {
        tech_leads: %w[lead],
        developers: %w[developer],
        product_owners: %w[owner],
        admin_users: %w[admin],
        departments: %w[department]
      }
      record = build_software_record(**serialized_values)
      record.save!

      record.reload
      serialized_values.each do |attribute, value|
        expect(record.public_send(attribute)).to eq(value)
      end
    end
  end
end
