# frozen_string_literal: true

class User < ApplicationRecord
  class ShibbolethIdentityError < StandardError; end

  ############################################################################################
  ## PeterGate Roles                                                                        ##
  ## The :user role is added by default and shouldn't be included in this list.             ##
  ## The :root_admin can access any page regardless of access settings. Use with caution!   ##
  ## The multiple option can be set to true if you need users to have multiple roles.       ##
  petergate(roles: %i[root_admin owner viewer manager], multiple: false) ##
  ############################################################################################
  validates :first_name, :last_name, :email, presence: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable

  def self.find_or_create_for_shibboleth!(attributes)
    normalized_identity = ShibbolethIdentityNormalizer.new(attributes).normalized
    first_name = normalized_identity[:first_name]
    last_name = normalized_identity[:last_name]
    email = normalized_identity[:email]
    eppn = normalized_identity[:eppn]

    existing_user = User.find_by(eppn: eppn)
    return existing_user if existing_user

    existing_user_by_email = User.find_by(email: email)
    if existing_user_by_email
      if existing_user_by_email.eppn.blank?
        existing_user_by_email.update!(eppn: eppn)
      elsif existing_user_by_email.eppn != eppn
        raise ShibbolethIdentityError, 'Unable to sign in: account identity conflict. Please contact support.'
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

  def active_for_authentication?
    super && active?
  end

  def inactive_message
    active? ? super : :not_approved
  end
end
