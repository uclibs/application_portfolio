# frozen_string_literal: true

class AdminMailerPreview < ActionMailer::Preview
  def request_new_software
    AdminMailer.new_software_request_mail(SoftwareRecord.id, SoftwareRecord.created_by)
  end
end
