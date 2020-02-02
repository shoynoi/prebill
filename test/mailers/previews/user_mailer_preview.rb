# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/reset_password_email
  def reset_password_email
    user = User.first
    user.generate_reset_password_token!
    UserMailer.reset_password_email(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/renew_service
  def renew_service
    user = User.find_by(name: "shoynoi")
    services = user.services.renewal
    UserMailer.renew_service(user, services)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/remind_services
  def remind_services
    user = User.find_by(name: "shoynoi")
    services = user.services.remind
    UserMailer.remind_services(user, services)
  end
end
