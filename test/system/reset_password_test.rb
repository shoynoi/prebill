# frozen_string_literal: true

require "application_system_test_case"

class ResetPasswordTest < ApplicationSystemTestCase
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "user can reset password" do
    user = users(:shoynoi)
    visit new_password_reset_path
    fill_in "email", with: user.email
    assert_difference "ActionMailer::Base.deliveries.count", 1 do
      click_button "パスワード再設定メールを送信"
    end
    assert_text "パスワード再設定用のメールを送信しました。"

    visit edit_password_reset_path(user.reload.reset_password_token)
    fill_in "user[password]", with: "newpass"
    fill_in "user[password_confirmation]", with: "newpass"
    click_button "パスワード変更"
    assert_text "パスワードの再設定が完了しました。"

    visit login_path
    fill_in "user[email]", with: user.email
    fill_in "user[password]", with: "newpass"
    click_button "ログイン"
    assert_text "ログインしました。"
  end

  test "return error when email address does not exist" do
    visit new_password_reset_path
    fill_in "email", with: "non-existent@example.com"
    assert_no_difference "ActionMailer::Base.deliveries.count" do
      click_button "パスワード再設定メールを送信"
    end
    assert_text "メールアドレスが正しくありません。"
  end
end
