# frozen_string_literal: true

module FlashMessagesHelper
  FLASH_APP_TITLE = 'UCL Application Portfolio'
  FLASH_TOAST_DELAY_MS = 3000
  FLASH_ALLOWED_TAGS = %w[br].freeze

  FLASH_TOAST_TYPES = {
    'success' => { icon: 'fa-check-circle', header_class: 'text-success' },
    'notice' => { icon: 'fa-info-circle', header_class: 'text-info' },
    'alert' => { icon: 'fa-exclamation-triangle', header_class: 'text-warning' },
    'error' => { icon: 'fa-times-circle', header_class: 'text-danger' },
    'warning' => { icon: 'fa-exclamation-triangle', header_class: 'text-warning' }
  }.freeze

  def alerts
    toasts = flash_toast_entries
    return if toasts.empty?

    render 'shared/alerts',
           flash_toasts: toasts,
           app_title: FLASH_APP_TITLE,
           toast_delay: FLASH_TOAST_DELAY_MS
  end

  def form_error_alert(message)
    content_tag(:div, flash_message_body(message), class: 'alert alert-danger mb-2', role: 'alert')
  end

  def flash_message_body(message)
    sanitize(message.to_s, tags: FLASH_ALLOWED_TAGS)
  end

  private

  def flash_toast_entries
    FLASH_TOAST_TYPES.filter_map do |type, style|
      message = flash[type]
      next if message.blank?

      style.merge(message: message)
    end
  end
end
