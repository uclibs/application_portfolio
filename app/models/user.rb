# frozen_string_literal: true

class User < ApplicationRecord
  class ShibbolethIdentityError < StandardError; end
  BLANK_FIRST_NAME = 'BlankFirstName'
  BLANK_LAST_NAME = 'BlankLastName'

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

  after_create :send_admin_mail

  def self.find_or_create_for_shibboleth!(attributes)
    first_name = normalized_name(attributes[:first_name], BLANK_FIRST_NAME)
    last_name = normalized_name(attributes[:last_name], BLANK_LAST_NAME)
    eppn = normalized_eppn(attributes[:eppn], first_name, last_name)
    email = normalized_email(attributes[:email], first_name, last_name)

    existing_user = User.find_by(eppn: eppn)
    return existing_user if existing_user

    User.create!(
      eppn: eppn,
      email: email,
      first_name: first_name,
      last_name: last_name,
      active: true,
      roles: 'viewer'
    )
  end

  def self.normalized_name(value, fallback)
    candidate = value.to_s.strip
    return fallback if blankish_identity_value?(candidate)

    candidate
  end

  def self.normalized_email(value, first_name, last_name)
    candidate = value.to_s.strip
    return candidate.downcase unless blankish_identity_value?(candidate)

    "#{first_name}.#{last_name}@uc.edu".downcase
  end

  def self.normalized_eppn(value, first_name, last_name)
    candidate = value.to_s.strip
    return candidate.downcase unless blankish_identity_value?(candidate)

    "#{first_name}.#{last_name}@uc.edu".downcase
  end

  def self.blankish_identity_value?(value)
    candidate = value.to_s.strip.downcase
    candidate.blank? || %w[nil null undefined (null)].include?(candidate)
  end

  def send_admin_mail
    NewUserSignupMailer.new_user_signup_mail(id, email, first_name, last_name).deliver_now
  end

  def active_for_authentication?
    super && active?
  end

  def inactive_message
    active? ? super : :not_approved
  end
end
