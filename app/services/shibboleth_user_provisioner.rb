# frozen_string_literal: true

class ShibbolethUserProvisioner
  class IdentityError < StandardError; end

  def self.find_or_create!(normalized_identity)
    first_name = normalized_identity.fetch(:first_name)
    last_name = normalized_identity.fetch(:last_name)
    email = normalized_identity.fetch(:email)
    eppn = normalized_identity.fetch(:eppn)

    existing_user = User.find_by(eppn: eppn)
    return existing_user if existing_user

    existing_user_by_email = User.find_by(email: email)
    if existing_user_by_email
      if existing_user_by_email.eppn.blank?
        existing_user_by_email.update!(eppn: eppn)
      elsif existing_user_by_email.eppn != eppn
        raise IdentityError, 'Unable to sign in: account identity conflict. Please contact support.'
      end
      return existing_user_by_email
    end

    User.create!(
      eppn: eppn,
      email: email,
      first_name: first_name,
      last_name: last_name,
      active: true,
      roles: 'viewer'
    )
  end
end
