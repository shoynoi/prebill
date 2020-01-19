# frozen_string_literal: true

require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "reset_password_email as text part" do
    user = users(:shoynoi)
    user.generate_reset_password_token!
    mail = UserMailer.reset_password_email(user)

    assert_emails 1 do
      mail.deliver_now
    end

    assert_equal "PreBill パスワードのリセット", mail.subject
    assert_equal ["shoynoi.jp@gmail.com"], mail.to
    assert_equal ["info@prebill.com"], mail.from
    password_reset_url = "#{ActionMailer::Base.default_url_options[:host]}:#{ActionMailer::Base.default_url_options[:port]}/password_resets/#{user.reset_password_token}/edit"
    assert_match %r(こんにちは、#{user.name}さん。), mail.text_part.body.to_s
    assert_match /#{password_reset_url}/, mail.text_part.body.to_s
  end

  test "reset_password_email as html part" do
    user = users(:shoynoi)
    user.generate_reset_password_token!
    mail = UserMailer.reset_password_email(user)

    assert_emails 1 do
      mail.deliver_now
    end

    assert_equal "PreBill パスワードのリセット", mail.subject
    assert_equal ["shoynoi.jp@gmail.com"], mail.to
    assert_equal ["info@prebill.com"], mail.from
    password_reset_url = "#{ActionMailer::Base.default_url_options[:host]}:#{ActionMailer::Base.default_url_options[:port]}/password_resets/#{user.reset_password_token}/edit"
    assert_match %r(こんにちは、#{user.name}さん。), mail.html_part.body.to_s
    assert_match /#{password_reset_url}/, mail.html_part.body.to_s
  end
end
