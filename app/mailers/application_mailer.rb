# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "PreBill <info@prebill.me>"
  layout "mailer"
end
