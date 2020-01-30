# frozen_string_literal: true

class UserMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.reset_password_email.subject
  #
  def reset_password_email(user)
    @user = User.find user.id
    @url  = edit_password_reset_url(@user.reset_password_token)
    mail(to: user.email,
         subject: "PreBill パスワードのリセット")
  end

  def renew_service(user, services)
    @user = user
    @services = services
    mail(to: user.email,
         subject: "PreBill 登録されたサービスが更新されました。")
  end
end
