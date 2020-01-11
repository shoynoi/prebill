# frozen_string_literal: true

require "application_system_test_case"

class ServicesTest < ApplicationSystemTestCase
  test "create a new service" do
    visit new_service_path
    fill_in "service_name", with: "テストサービス"
    select "月額", from: "プラン"
    fill_in "service_price", with: 1200
    fill_in "service_renewed_on", with: "2019/12/31"
    fill_in "service_notified_on", with: "2019/12/20"
    assert_difference "Service.count", 1 do
      click_button "登録"
      assert_text "サービスを登録しました。"
    end
  end

  test "update a service" do
    service = services(:service_1)
    visit edit_service_path(service)
    fill_in "service_name", with: "テストサービス(修正)"
    select "年額", from: "プラン"
    fill_in "service_price", with: 1800
    fill_in "service_renewed_on", with: "2020/1/10"
    fill_in "service_notified_on", with: "2020/01/05"
    click_button "登録"
    assert_text "サービスを修正しました。"
  end

  test "destroy a service" do
    visit root_path
    within ".service:first-child" do
      accept_confirm do
        click_link "削除"
      end
    end
    assert_difference "Service.count", -1 do
      assert_text "サービスを削除しました。"
    end
  end
end
