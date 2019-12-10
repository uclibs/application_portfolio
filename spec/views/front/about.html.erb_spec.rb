# frozen_string_literal: true

require 'rails_helper'

describe 'front/about' do
  it 'displays an about page' do
    render
    expect(rendered).to have_text('Application Portfolio is a portfolio that manages the applications that are available')
  end
end
