# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid when all required fields are provided' do
    user = User.new(first_name: 'Random', last_name: 'User', email: 'random@uc.edu')

    expect(user).to be_valid
  end

  it 'is invalid without first_name' do
    user = User.new(last_name: 'User', email: 'random@uc.edu')

    expect(user).not_to be_valid
  end

  it 'is invalid without last_name' do
    user = User.new(first_name: 'Random', email: 'random@uc.edu')

    expect(user).not_to be_valid
  end

  it 'is invalid without email' do
    user = User.new(first_name: 'Random', last_name: 'User')

    expect(user).not_to be_valid
  end

  it 'is valid with a non-UC email when required fields are present' do
    user = User.new(first_name: 'Random', last_name: 'User', email: 'random@example.com')

    expect(user).to be_valid
  end

  it 'is valid with campus email domains' do
    %w[testadmin@uc.edu testadmin2@mail.uc.edu testadmin3@ucmail.uc.edu].each do |email|
      user = User.new(first_name: 'Test', last_name: 'User', email: email)

      expect(user).to be_valid
    end
  end

  describe '#active_for_authentication?' do
    it 'returns true for active users' do
      user = User.new(first_name: 'Test', last_name: 'User', email: 'active@uc.edu', active: true)

      expect(user.active_for_authentication?).to be(true)
    end

    it 'returns false for inactive users' do
      user = User.new(first_name: 'Test', last_name: 'User', email: 'inactive@uc.edu', active: false)

      expect(user.active_for_authentication?).to be(false)
    end
  end

  describe '#inactive_message' do
    it 'returns the default devise message for active users' do
      user = User.new(first_name: 'Test', last_name: 'User', email: 'active@uc.edu', active: true)

      expect(user.inactive_message).to eq(:inactive)
    end

    it 'returns :not_approved for inactive users' do
      user = User.new(first_name: 'Test', last_name: 'User', email: 'inactive@uc.edu', active: false)

      expect(user.inactive_message).to eq(:not_approved)
    end
  end
end
