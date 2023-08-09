# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChangeRequest, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:change_title) }
  end

  describe 'associations' do
    it { should belong_to(:software_record) }
  end
end
