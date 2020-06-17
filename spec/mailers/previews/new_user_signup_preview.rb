# frozen_string_literal: true

class NewUserSignupMailer < ActionMailer::Preview
  def new_user_signup
    NewUserSignupMailer.new_user_signup_mail(User.id, User.email, User.first_name, User.last_name)
  end
end
