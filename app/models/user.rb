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
  validate :allow_uc_domains
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, password_length: 10..128

  after_create :send_admin_mail

  def self.find_or_create_for_shibboleth!(attributes)
    email = attributes[:email].to_s.strip.downcase
    first_name = attributes[:first_name].to_s.strip
    last_name = attributes[:last_name].to_s.strip

    raise ShibbolethIdentityError, 'Unable to sign in: missing required email from Shibboleth.' if email.blank?
    raise ShibbolethIdentityError, 'Unable to sign in: missing required name from Shibboleth.' if first_name.blank? || last_name.blank?

    existing_user = User.find_by(email: email)
    return existing_user if existing_user

    random_password = Devise.friendly_token(32)

    User.create!(
      email: email,
      first_name: first_name,
      last_name: last_name,
      active: true,
      roles: 'viewer',
      password: random_password,
      password_confirmation: random_password
    )
  end

  def allow_uc_domains
    allowed_domains = ['uc.edu', 'mail.uc.edu', 'ucmail.uc.edu']
    errors.add(:email, 'for Signup must be an UC email') unless allowed_domains.any? do |domain|
                                                                  email.end_with?(domain)
                                                                end
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
