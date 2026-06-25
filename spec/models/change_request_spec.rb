# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChangeRequest, type: :model do
  let!(:software_record) { SoftwareRecord.create!(software_record_attributes) }

  def build_change_request(**overrides)
    described_class.new(
      software_record:,
      change_title: 'Change title',
      **overrides
    )
  end

  describe 'validations' do
    it 'requires change_title' do
      record = build_change_request(change_title: nil)

      expect(record).not_to be_valid
      expect(record.errors[:change_title]).to include("can't be blank")
    end

    %i[application_pages number_roles authentication_needed custom_error_pages].each do |attribute|
      it "does not require #{attribute}" do
        expect(build_change_request(attribute => nil)).to be_valid
      end
    end
  end
end
