# frozen_string_literal: true

# Admin Mailer on Software Record request
class AdminMailer < ApplicationMailer
  default from: 'uclappdev@uc.edu'

  def new_software_request_mail(id, name)
    @id = id
    @name = name
    @template = 'new_software_request_mail'
    @users = User.where(roles: 'root_admin')
    @users.each do |admin|
      mail(to: admin.email, subject: 'Software Requested for UCL Application Portfolio',
           template_name: @template).deliver
    end
  end
end
