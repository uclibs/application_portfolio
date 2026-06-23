# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TurboLinkHelper, type: :helper do
  describe '#delete_link' do
    it 'renders a Turbo DELETE link with confirmation' do
      link = delete_link('Delete', '/records/1', class: 'btn btn-danger')

      expect(link).to include('data-turbo-method="delete"')
      expect(link).to include('data-turbo-confirm="Are you sure?"')
      expect(link).to include('class="btn btn-danger"')
    end
  end

  describe '#logout_link' do
    it 'renders a Turbo DELETE link without confirmation' do
      link = logout_link('Logout', '/users/sign_out', class: 'text-white')

      expect(link).to include('data-turbo-method="delete"')
      expect(link).not_to include('data-turbo-confirm')
      expect(link).to include('class="text-white"')
    end
  end
end
