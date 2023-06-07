# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChangeRequest, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:change_title) }
    it { should validate_presence_of(:application_pages) }
    it { should validate_presence_of(:number_roles) }
    it { should validate_presence_of(:authentication_needed) }
    it { should validate_presence_of(:custom_error_pages) }
  end

  describe 'associations' do
    it { should belong_to(:software_record) }
  end
end
