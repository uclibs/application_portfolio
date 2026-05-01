# frozen_string_literal: true

class ShibbolethIdentityResolver
  def initialize(env:, allow_legacy_env_keys: false)
    @env = env || {}
    @allow_legacy_env_keys = allow_legacy_env_keys
  end

  def raw_attributes
    @raw_attributes ||= ShibbolethAttributeReader.new(@env, allow_legacy_env_keys: @allow_legacy_env_keys).attributes
  end

  def normalized_identity
    @normalized_identity ||= ShibbolethIdentityNormalizer.new(raw_attributes).normalized
  end
end
