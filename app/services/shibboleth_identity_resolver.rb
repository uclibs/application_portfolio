# frozen_string_literal: true

class ShibbolethIdentityResolver
  def initialize(env:)
    @env = env || {}
  end

  def raw_attributes
    @raw_attributes ||= ShibbolethAttributeReader.new(@env).attributes
  end

  def normalized_identity
    @normalized_identity ||= ShibbolethIdentityNormalizer.new(raw_attributes).normalized
  end
end
