# frozen_string_literal: true

require 'rails_helper'

describe 'front/index' do
  context 'when user is not logged in' do
    it 'displays a login link' do
      render
      expect(rendered).to have_link('Login', href: new_user_session_path)
    end
  end
end

describe 'front/index' do
  context 'when user is created' do
    before(:each) do
      allow(view).to(receive(:user_signed_in?) { true }) && allow(view).to(receive(:current_user) { FactoryBot.build(:admin) })
    end

    it 'displays who is logged in' do
      render
      expect(rendered).to have_text('Logged in as admin@test.com')
      expect(controller.request.path_parameters[:controller]).to eq('front')
    end

    it 'displays a logout link' do
      render
      expect(rendered).to have_link('Logout', href: destroy_user_session_path)
    end
  end
end
