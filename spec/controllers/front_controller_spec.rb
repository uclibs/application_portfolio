# frozen_string_literal: true

require 'rails_helper'

describe FrontController do
  describe '#index' do
    it 'renders the index page' do
      get :index
      expect(response.status).to eq(200)
      expect(response).to render_template('index')
    end
  end
end
