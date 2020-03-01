# frozen_string_literal: true

require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  test "sign up" do
    visit signup_path
    fill_in "user[name]", with: "testuser"
    fill_in "user[email]", with: "test@example.com"
    fill_in "user[password]", with: "testtest"
    fill_in "user[password_confirmation]", with: "testtest"
    assert_difference "User.count", 1 do
      click_button "ユーザー登録"
    end
    assert_text "アカウントを作成しました！"
  end

  test "show errors in sign up form when invalid" do
    visit signup_path
    fill_in "user[name]", with: ""
    fill_in "user[email]", with: ""
    fill_in "user[password]", with: ""
    fill_in "user[password_confirmation]", with: ""
    click_button "ユーザー登録"
    assert_text "入力内容にエラーがありました。"
  end

  test "update user" do
    login_user "shoynoi.jp@gmail.com", "secret"
    visit edit_my_account_path
    fill_in "user[name]", with: "yoshino"
    fill_in "user[email]", with: "yoshino@example.com"
    fill_in "user[password]", with: "pwupdate"
    fill_in "user[password_confirmation]", with: "pwupdate"
    click_button "更新する"
    assert_text "ユーザー情報を変更しました。"
  end

  test "close account" do
    login_user "shoynoi.jp@gmail.com", "secret"
    visit close_my_account_path
    accept_confirm do
      click_link "退会する"
    end
    assert_difference "User.count", -1 do
      assert_text "退会が完了しました。"
    end
  end
end
