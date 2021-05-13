# frozen_string_literal: true

require 'rails_helper'

describe 'front/welcome' do
  before(:each) do
    allow(view).to(receive(:user_signed_in?) { true }) && allow(view).to(receive(:current_user) do
                                                                           FactoryBot.build(:admin)
                                                                         end)
  end

  it 'displays an welcome page' do
    render
    expect(rendered).to have_text('Logged in as')
  end
end
