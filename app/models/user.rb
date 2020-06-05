# frozen_string_literal: true

class User < ApplicationRecord
  ############################################################################################
  ## PeterGate Roles                                                                        ##
  ## The :user role is added by default and shouldn't be included in this list.             ##
  ## The :root_admin can access any page regardless of access settings. Use with caution!   ##
  ## The multiple option can be set to true if you need users to have multiple roles.       ##
  petergate(roles: %i[root_admin owner viewer manager], multiple: false) ##
  ############################################################################################
  validates_presence_of :first_name, :last_name, :email
  validate :allow_uc_domains
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, password_length: 10..128

  after_create :send_admin_mail

  def allow_uc_domains
    allowed_domains = ['uc.edu', 'mail.uc.edu', 'ucmail.uc.edu']
    errors.add(:email, 'for Signup must be an UC email') unless allowed_domains.any? { |domain| email.end_with?(domain) }
  end
  
  def send_admin_mail
    NewUserSignupMailer.new_user_signup_mail(self.id, self.email, self.first_name, self.last_name).deliver_now
  end

  def active_for_authentication?
    super && active?
  end

  def inactive_message
    active? ? super : :not_approved
  end
end
