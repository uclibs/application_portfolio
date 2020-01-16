# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'uclappdev@uc.edu'
  layout 'mailer'
end
