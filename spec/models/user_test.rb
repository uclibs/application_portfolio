# frozen_string_literal: true

require 'rails_helper'

class UserTest < ActiveSupport::TestCase
  RSpec.describe User, type: :model do
    it 'is valid user if all required fields are provided' do
      user = User.new(first_name: 'Random', last_name: 'User', email: 'random@example.com', password: 'random@123', password_confirmation: 'random@123')
      expect(user).to be_valid
    end
    it 'is not valid user without a single mandatory field (without first_name)' do
      user = User.new(last_name: 'User', email: 'random@example.com', password: 'random@123', password_confirmation: 'random@123')
      expect(user).to_not be_valid
    end
    it 'is not valid without a single mandatory field (without last_name)' do
      user = User.new(first_name: 'Random', email: 'random@example.com', password: 'random@123', password_confirmation: 'random@123')
      expect(user).to_not be_valid
    end
    it 'is not valid without a single mandatory field (without email)' do
      user = User.new(first_name: 'Random', last_name: 'User', password: 'random@123', password_confirmation: 'random@123')
      expect(user).to_not be_valid
    end
    it 'is not valid without a single mandatory field (without password)' do
      user = User.new(first_name: 'Random', last_name: 'User', email: 'random@example.com', password_confirmation: 'random@123')
      expect(user).to_not be_valid
    end
  end
end
