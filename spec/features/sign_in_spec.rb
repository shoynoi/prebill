# frozen_string_literal: true

require "rails_helper"

RSpec.feature "SignIns", type: :feature do
  let!(:user) { create(:user, :activated, email: "tester@example.com") }

  scenario "sign in" do
    login_user "tester@example.com", "secret"
    expect(current_path).to eq root_path
    expect(page).to have_content "ログインしました。"
  end

  scenario "sign in with wrong password" do
    login_user "tester@example.com", "wrongpass"
    expect(current_path).to eq login_path
    expect(page).to have_content "メールアドレスかパスワードが正しくありません。"
  end

  scenario "display dashboard in root path after sign in" do
    visit root_path
    expect(page).to_not have_content("利用中のサービス", exact: true)
    login_user "tester@example.com", "secret"
    visit root_path
    within(".page-body__title") do
      expect(page).to have_content("利用中のサービス", exact: true)
    end
  end

  scenario "require login" do
    visit edit_my_account_path
    expect(page).to have_content "ログインしてください。"
    expect(current_path).to eq root_path
  end
end
