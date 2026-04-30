# frozen_string_literal: true

require 'rails_helper'

class UserTest < ActiveSupport::TestCase
  RSpec.describe User, type: :model do
    it 'is valid user if all required fields are provided' do
      user = User.new(first_name: 'Random', last_name: 'User', email: 'random@uc.edu')
      expect(user).to be_valid
    end
    it 'is not valid user without a single mandatory field (without first_name)' do
      user = User.new(last_name: 'User', email: 'random@uc.edu')
      expect(user).to_not be_valid
    end
    it 'is not valid without a single mandatory field (without last_name)' do
      user = User.new(first_name: 'Random', email: 'random@uc.edu')
      expect(user).to_not be_valid
    end
    it 'is not valid without a single mandatory field (without email)' do
      user = User.new(first_name: 'Random', last_name: 'User')
      expect(user).to_not be_valid
    end
    it 'is not valid without a UC domain' do
      user = User.new(first_name: 'Random', last_name: 'User', email: 'random@example.com')
      expect(user).to_not be_valid
    end
    it 'is valid with allowed domains' do
      user = User.new(first_name: 'Test', last_name: 'Admin', email: 'testadmin@uc.edu')
      expect(user).to be_valid
    end
    it 'is valid with allowed domains' do
      user = User.new(first_name: 'Test', last_name: 'Admin2', email: 'testadmin2@mail.uc.edu')
      expect(user).to be_valid
    end
    it 'is valid with allowed domains' do
      user = User.new(first_name: 'Test', last_name: 'Admin3', email: 'testadmin3@ucmail.uc.edu')
      expect(user).to be_valid
    end
  end
end
