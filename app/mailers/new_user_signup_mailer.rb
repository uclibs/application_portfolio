# frozen_string_literal: true

# Admin Mailer on Software Record request
class NewUserSignupMailer < ApplicationMailer
  default from: 'uclappdev@uc.edu'

  def new_user_signup_mail(id, email, first_name, last_name)
    @id = id
    @email = email
    @name = first_name.to_s + ' ' + last_name
    @template = 'new_user_signup_mail.html.erb'
    @users = User.where(roles: 'root_admin')
    @users.each do |admin|
      mail(to: admin.email, subject: 'New User registered in UCL Application Portfolio', template_name: @template).deliver
    end
  end
end
