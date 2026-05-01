# frozen_string_literal: true

class ShibbolethAttributeReader
  ATTRIBUTE_MAP = {
    eppn: 'eppn',
    email: 'mail',
    first_name: 'givenName',
    last_name: 'sn'
  }.freeze

  def initialize(env)
    @env = env || {}
  end

  def attributes
    {
      eppn: value_for(ATTRIBUTE_MAP[:eppn]),
      email: value_for(ATTRIBUTE_MAP[:email]),
      first_name: value_for(ATTRIBUTE_MAP[:first_name]),
      last_name: value_for(ATTRIBUTE_MAP[:last_name])
    }
  end

  private

  def value_for(attribute_name)
    normalized = attribute_name.to_s.tr('-', '_')
    canonical_header_key = "HTTP_#{normalized.upcase}"
    trusted_keys = [
      canonical_header_key,
      "REDIRECT_#{canonical_header_key}",
      attribute_name.to_s,
      attribute_name.to_s.downcase,
      attribute_name.to_s.upcase
    ].uniq

    trusted_keys.each do |key|
      value = @env[key].to_s.strip
      return value if value.present?
    end

    nil
  end
end
