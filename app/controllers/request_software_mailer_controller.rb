# frozen_string_literal: true

# Software Request mailer
class RequestSoftwareMailerController < ActionMailer::Base
  def send_mail(_id, _name)
    default from: 'uclappdev@uc.edu'

    mail(
      to: 'mallepvl@mail.uc.edu',
      subject: 'New Software Request',
      template_name: 'new_software_request_mail.html.erb'
    )
  end
end
