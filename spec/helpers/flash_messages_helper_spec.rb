# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlashMessagesHelper, type: :helper do
  describe '#alerts' do
    it 'renders nothing when flash is empty' do
      alerts

      expect(rendered).to be_blank
    end

    it 'renders a Bootstrap toast for notice' do
      flash[:notice] = 'Status was successfully created.'
      alerts

      expect(rendered).to have_css('.flash-toast-container .toast', text: /Status was successfully created/)
      expect(rendered).to have_css('.toast-header', text: FlashMessagesHelper::FLASH_APP_TITLE)
      expect(rendered).to include('data-bs-delay="3000"')
    end

    it 'renders a Bootstrap toast for alert with allowed HTML' do
      flash[:alert] = 'Permission denied.<br/>Contact the administrator.'
      alerts

      expect(rendered).to have_css('.toast-body br')
      expect(rendered).to include('Permission denied.')
    end

    %w[success error warning].each do |type|
      it "renders a Bootstrap toast for #{type}" do
        flash[type.to_sym] = "#{type.capitalize} message."
        alerts

        expect(rendered).to have_css('.flash-toast', text: /#{type.capitalize} message/)
      end
    end

    it 'renders each present flash type' do
      flash[:notice] = 'Saved.'
      flash[:error] = 'Failed.'
      alerts

      expect(rendered).to have_css('.flash-toast', count: 2)
    end

    it 'renders type-specific toast icons' do
      flash[:notice] = 'Saved.'
      flash[:error] = 'Failed.'
      alerts

      expect(rendered).to have_css('.fa-info-circle.text-info')
      expect(rendered).to have_css('.fa-times-circle.text-danger')
    end
  end

  describe '#flash_message_body' do
    it 'allows br tags in flash copy' do
      expect(flash_message_body('Line one<br/>Line two')).to include('<br>')
      expect(flash_message_body('Line one<br/>Line two')).to include('Line one')
    end

    it 'strips disallowed HTML tags' do
      body = flash_message_body('<script>alert("x")</script>Safe text')

      expect(body).not_to include('<script>')
      expect(body).to include('Safe text')
    end
  end

  describe '#form_error_alert' do
    it 'renders a Bootstrap danger alert with sanitized HTML' do
      alert = form_error_alert('Name cannot be blank.<br/>Try again.')

      expect(alert).to include('alert alert-danger')
      expect(alert).to include('Name cannot be blank.')
      expect(alert).to include('<br>')
    end
  end
end
