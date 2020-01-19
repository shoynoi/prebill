# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "PreBill <info@prebill.com>"
  layout "mailer"
end
