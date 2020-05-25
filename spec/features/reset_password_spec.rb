# frozen_string_literal: true

require "rails_helper"

RSpec.feature "ResetPasswords", type: :feature do
  let!(:user) { create(:user, :activated, email: "tester@example.com") }

  scenario "user can reset password" do
    visit new_password_reset_path
    fill_in "email", with: user.email
    expect {
      click_button "パスワード再設定メールを送信"
    }.to change(ActionMailer::Base.deliveries, :count).by(1)
    expect(page).to have_content "パスワード再設定用のメールを送信しました。"

    visit edit_password_reset_path(user.reload.reset_password_token)
    fill_in "user[password]", with: "newpass"
    fill_in "user[password_confirmation]", with: "newpass"
    click_button "パスワード変更"
    expect(page).to have_content "パスワードの再設定が完了しました。"

    visit login_path
    fill_in "user[email]", with: user.email
    fill_in "user[password]", with: "newpass"
    click_button "ログイン"
    expect(page).to have_content "ログインしました。"
  end

  scenario "return error when email address does not exist" do
    visit new_password_reset_path
    fill_in "email", with: "non-existent@example.com"
    expect {
      click_button "パスワード再設定メールを送信"
    }.to_not change(ActionMailer::Base.deliveries, :count)
    expect(page).to have_content "メールアドレスが正しくありません。"
  end
end
