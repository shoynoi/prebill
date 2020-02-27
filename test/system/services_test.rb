# frozen_string_literal: true

require "application_system_test_case"

class ServicesTest < ApplicationSystemTestCase
  def setup
    login_user "shoynoi.jp@gmail.com", "secret"
  end

  test "create a new service" do
    visit new_service_path
    fill_in "service[name]", with: "テストサービス"
    select "月額", from: "プラン"
    fill_in "service[price]", with: 1200
    fill_in "service[renewed_on]", with: "2019/12/31"
    fill_in "service[remind_on]", with: "2019/12/20"
    fill_in "service[description]", with: "テストメモ"
    assert_difference "Service.count", 1 do
      click_on "登録"
      assert_text "サービスを登録しました。"
    end
  end

  test "update a service" do
    service = services(:spotify)
    visit edit_service_path(service)
    fill_in "service[name]", with: "テストサービス(修正)"
    select "年額", from: "プラン"
    fill_in "service[price]", with: 1800
    fill_in "service[renewed_on]", with: "2020/1/10"
    fill_in "service[remind_on]", with: "2020/01/05"
    fill_in "service[description]", with: "テストメモ(修正)"
    click_on "修正"
    assert_text "サービスを修正しました。"
  end

  test "destroy a service" do
    visit root_path
    within ".list:first-child" do
      find(".list__expand").click
      accept_confirm do
        click_link "削除"
      end
    end
    assert_difference "Service.count", -1 do
      assert_text "サービスを削除しました。"
    end
  end

  test "only services associated with the user will be displayed" do
    visit root_path
    within(".list-group") do
      assert_text "Spotify"
    end
    login_user "akira@example.com", "secret"
    within(".list-group") do
      assert_no_text "Spotify"
      assert_text "Amazon Prime"
    end
  end

  test "autocomplete input when filled in service name" do
    visit new_service_path
    fill_in "service[name]", with: "hu"
    within(".autocomplete") do
      assert_text "Hulu"
      find(".selected").click
    end
    assert_equal "Hulu", find("#service_name").value
    assert_equal "monthly", find("#service_plan").value
    assert_equal "1026", find("#service_price").value
  end
end
