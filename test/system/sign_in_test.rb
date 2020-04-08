# frozen_string_literal: true

require "application_system_test_case"

class SignInTest < ApplicationSystemTestCase
  test "sign in" do
    visit login_path
    fill_in "user[email]", with: "shoynoi.jp@gmail.com"
    fill_in "user[password]", with: "secret"
    click_button "ログイン"
    assert_equal root_path, current_path
    assert_text "ログインしました。"
  end

  test "sign in with wrong password" do
    visit login_path
    fill_in "user[email]", with: "shoynoi.jp@gmail.com"
    fill_in "user[password]", with: "wrongpass"
    click_button "ログイン"
    assert_text "メールアドレスかパスワードが正しくありません。"
  end

  test "display dashboard in root path after sign in" do
    visit root_path
    assert_no_text "Dashboard"
    login_user "shoynoi.jp@gmail.com", "secret"
    visit root_path
    assert_text "利用中のサービス"
  end

  test "require login" do
    visit edit_my_account_path
    assert_text "ログインしてください。"
  end
end
