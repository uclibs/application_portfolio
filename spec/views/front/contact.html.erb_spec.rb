# frozen_string_literal: true

require 'rails_helper'

describe 'front/contact' do
  it 'dipslays a contact page' do
    render
    expect(rendered).to have_text('2911 Woodside Drive, University of Cincinnati, Langsam Library, Cincinnati, OH 45221')
  end
end
