# frozen_string_literal: true

# Software Request mailer
class RequestSoftwareMailerController < ActionMailer::Base
  def send_mail
    default from: 'uclappdev@uc.edu'

    mail(
      to: 'mallepvl@mail.uc.edu',
      subject: 'Welcome'
    )
  end
end
