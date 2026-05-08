# frozen_string_literal: true

class ShibbolethIdentityNormalizer
  BLANK_FIRST_NAME = 'BlankFirstName'
  BLANK_LAST_NAME = 'BlankLastName'
  NULL_LIKE_VALUES = %w[nil null undefined (null)].freeze

  def initialize(attributes)
    @attributes = attributes || {}
  end

  def normalized
    first_name = normalized_name(@attributes[:first_name], BLANK_FIRST_NAME)
    last_name = normalized_name(@attributes[:last_name], BLANK_LAST_NAME)

    {
      first_name: first_name,
      last_name: last_name,
      email: normalized_email(@attributes[:email], first_name, last_name),
      eppn: normalized_eppn(@attributes[:eppn], @attributes[:email], first_name, last_name)
    }
  end

  private

  def normalized_name(value, fallback)
    candidate = value.to_s.strip
    return fallback if blankish_identity_value?(candidate)

    candidate
  end

  def normalized_email(value, first_name, last_name)
    candidate = value.to_s.strip
    return candidate.downcase unless blankish_identity_value?(candidate)

    "#{first_name}.#{last_name}@uc.edu".downcase
  end

  def normalized_eppn(value, email_value, first_name, last_name)
    candidate = value.to_s.strip
    return candidate.downcase unless blankish_identity_value?(candidate)

    email_candidate = email_value.to_s.strip
    return email_candidate.downcase unless blankish_identity_value?(email_candidate)

    "#{first_name}.#{last_name}@uc.edu".downcase
  end

  def blankish_identity_value?(value)
    candidate = value.to_s.strip.downcase
    candidate.blank? || NULL_LIKE_VALUES.include?(candidate)
  end
end
