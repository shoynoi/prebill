# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Homes", type: :feature do
  let!(:user) { create(:user, :activated, email: "tester@example.com") }

  scenario "GET root path without sign in" do
    visit root_path
    expect(title).to eq "PreBill"
  end

  scenario "GET root path with sign in" do
    login_user "tester@example.com", "secret"
    visit root_path
    expect(title).to eq "利用中のサービス - PreBill"
  end

  scenario "display services list associated with the user" do
    create(:service, name: "Spotify", user: user)
    other_user = create(:user, :activated, email: "othertester@example.com")
    create(:service, name: "Amazon Prime", user: other_user)
    login_user "tester@example.com", "secret"
    visit root_path
    within(".list-group") do
      expect(page).to have_content("Spotify")
    end
    login_user "othertester@example.com", "secret"
    within(".list-group") do
      expect(page).to have_content("Amazon Prime")
      expect(page).to_not have_content("Spotify")
    end
  end

  scenario "display assist message when the user has not registered any service" do
    login_user "tester@example.com", "secret"
    visit root_path
    expect(page).to have_content("サービスを登録して、管理を始めましょう！")
  end
end
