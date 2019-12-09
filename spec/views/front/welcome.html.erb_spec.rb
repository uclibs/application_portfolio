# frozen_string_literal: true

require 'rails_helper'

describe 'front/welcome' do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in user
  end
  it 'displays an welcome page' do
    render
    expect(rendered).to have_text('Logged in as')
  end
end
