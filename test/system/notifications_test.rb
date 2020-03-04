# frozen_string_literal: true

require "application_system_test_case"

class NotificationsTest < ApplicationSystemTestCase
  test "display message when no notifications" do
    login_user "inactive@example.com", "secret"
    find(".header-notification__label").click
    within(".header-dropdown__container") do
      assert_text "通知はありません"
    end
  end
end
