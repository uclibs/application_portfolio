# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewUserSignupMailer, type: :mailer do
  describe 'new_user_signup_mail' do
    let(:user) do
      User.create!(
        first_name: 'Tony',
        last_name: 'Stark',
        email: 'tony.stark@uc.edu',
        roles: 'viewer',
        department: 'Robotics',
        title: 'Iron Man',
        password: 'jarvis_12345',
        password_confirmation: 'jarvis_12345'
      )
    end
    it 'sends an email on new software request' do
      FactoryBot.create(:admin)
      mail = described_class.new_user_signup_mail(user.id, user.email, user.first_name, user.last_name).deliver_now
      expect(mail.subject).to eq('New User registered in UCL Application Portfolio')
      expect(mail.from).to eq(['uclappdev@uc.edu'])
      expect(mail.body.encoded).to match(user.first_name + ' ' + user.last_name)
      expect(mail.body.encoded).to match('A New User is registered in the UCL Application Portfolio. Please find the details of the new user below.')
    end
  end
end
