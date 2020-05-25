# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Services", type: :feature do
  let!(:user) { create(:user, :activated, email: "tester@example.com") }

  background do
    login_user "tester@example.com", "secret"
  end

  scenario "create a new service" do
    visit new_service_path
    expect {
      fill_in "service[name]", with: "テストサービス"
      select "月額", from: "プラン"
      fill_in "service[price]", with: 1200
      fill_in "service[renewed_on]", with: Date.parse("2019-12-31")
      fill_in "service[remind_on]", with: Date.parse("2019-12-20")
      fill_in "service[description]", with: "テストメモ"
      click_button "登録"
    }.to change(Service, :count).by(1)
    expect(page).to have_content "サービスを登録しました。"
  end

  scenario "update a service" do
    service = create(:service, user: user)
    visit edit_service_path(service)
    fill_in "service[name]", with: "テストサービス(修正)"
    select "年額", from: "プラン"
    fill_in "service[price]", with: 1800
    fill_in "service[renewed_on]", with: "2020/1/10"
    fill_in "service[remind_on]", with: "2020/01/05"
    fill_in "service[description]", with: "テストメモ(修正)"
    click_button "修正"
    expect(page).to have_content "サービスを修正しました。"
  end

  scenario "destroy a service", js: true do
    create(:service, user: user)
    visit root_path
    within ".list:first-child" do
      find(".list__expand").click
      click_link "削除"
    end
    expect {
      expect(page.accept_confirm).to eq "本当によろしいですか?"
      expect(page).to have_content "サービスを削除しました。"
    }.to change(Service, :count).by(-1)
  end

  scenario "autocomplete input when filled in service name", js: true do
    create(:preset_service)
    visit new_service_path
    fill_in "service[name]", with: "hu"
    within(".autocomplete") do
      expect(page).to have_content "Hulu"
      find(".selected").click
    end
    expect(find("#service_name").value).to eq "Hulu"
    expect(find("#service_plan").value).to eq "monthly"
    expect(find("#service_price").value).to eq "1026"
  end
end
