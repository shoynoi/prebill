# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Users", type: :feature do
  include ActiveJob::TestHelper

  scenario "sign up and activate account" do
    visit signup_path
    perform_enqueued_jobs do
      expect {
        fill_in "user[name]", with: "testuser"
        fill_in "user[email]", with: "test@example.com"
        fill_in "user[password]", with: "testtest"
        fill_in "user[password_confirmation]", with: "testtest"
        click_button "アカウントを作成する"
      }.to change(User, :count).by(1)
    end

    expect(page).to have_content("アカウントを作成しました！メールアドレスを確認してアカウントを有効化してください。")
    expect(current_path).to eq root_path

    mail = ActionMailer::Base.deliveries.last

    aggregate_failures do
      expect(mail.to).to eq ["test@example.com"]
      expect(mail.from).to eq ["info@prebill.me"]
      expect(mail.subject).to eq "PreBill メールアドレスの確認"
      expect(mail.html_part.body.to_s).to match "PreBillへ会員登録していただき、ありがとうございます。"
    end

    token = User.find_by(name: "testuser").activation_token
    visit activate_user_path(token)
    expect(current_path).to eq root_path
    expect(page).to have_content("メールアドレスの確認が完了しました！")
  end

  scenario "show errors in sign up form when invalid" do
    visit signup_path
    expect {
      fill_in "user[name]", with: ""
      fill_in "user[email]", with: ""
      fill_in "user[password]", with: ""
      fill_in "user[password_confirmation]", with: ""
      click_button "アカウントを作成する"
    }.to_not change(User, :count)
    expect(page).to have_content("入力内容にエラーがありました。")
  end

  scenario "can not login when not account activation" do
    visit signup_path
    fill_in "user[name]", with: "testuser"
    fill_in "user[email]", with: "test@example.com"
    fill_in "user[password]", with: "testtest"
    fill_in "user[password_confirmation]", with: "testtest"
    click_button "アカウントを作成する"
    login_user "test@example.com", "testtest"
    assert_text "メールを確認して、アカウントを有効化してください。"
  end

  scenario "can not login when account activation token is expired" do
    visit signup_path
    fill_in "user[name]", with: "testuser"
    fill_in "user[email]", with: "test@example.com"
    fill_in "user[password]", with: "testtest"
    fill_in "user[password_confirmation]", with: "testtest"
    click_button "アカウントを作成する"
    travel_to 1.month.since do
      token = User.find_by(email: "test@example.com").activation_token
      visit activate_user_path(token)
      expect(current_path).to eq root_path
      expect(page).to have_content("トークンの有効期限が切れています")
    end
  end

  scenario "update user" do
    create(:user, :activated, email: "tester@example.com")
    login_user "tester@example.com", "secret"
    visit edit_my_account_path
    fill_in "user[name]", with: "update name"
    fill_in "user[email]", with: "update@example.com"
    fill_in "user[password]", with: "pwupdate"
    fill_in "user[password_confirmation]", with: "pwupdate"
    click_button "更新する"
    expect(page).to have_content("ユーザー情報を変更しました。")
  end

  scenario "close account", js: true do
    create(:user, :activated, email: "tester@example.com")
    login_user "tester@example.com", "secret"
    visit close_my_account_path
    click_link "退会する"
    expect {
      expect(page.accept_confirm).to eq "アカウントを削除します。本当によろしいですか?"
      expect(page).to have_content("退会が完了しました。")
    }.to change(User, :count).by(-1)
  end
end
