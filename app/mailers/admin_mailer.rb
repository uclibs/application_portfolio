# frozen_string_literal: true

# Admin Mailer on Software Record request
class AdminMailer < ApplicationMailer
  default from: 'uclappdev@uc.edu'
  def send_mail(_id, _name)
    mail(
      to: 'mallepvl@mail.uc.edu',
      subject: 'New Software Request'
    )
  end
end
