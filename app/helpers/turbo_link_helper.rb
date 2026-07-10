# frozen_string_literal: true

module TurboLinkHelper
  DELETE_CONFIRMATION = 'Are you sure?'

  def delete_link(name, url, **options)
    link_to name, url, **options,
           data: { turbo_method: :delete, turbo_confirm: DELETE_CONFIRMATION }.merge(options.fetch(:data, {}))
  end

  def logout_link(name, url, **options)
    link_to name, url, **options, data: { turbo_method: :delete }.merge(options.fetch(:data, {}))
  end
end
