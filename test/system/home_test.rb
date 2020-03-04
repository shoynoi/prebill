# frozen_string_literal: true

require "application_system_test_case"

class HomeTest < ApplicationSystemTestCase
  test "GET root path without sign in" do
    visit root_path
    assert_equal "PreBill", title
  end

  test "GET root path with sign in" do
    login_user "shoynoi.jp@gmail.com", "secret"
    visit root_path
    assert_equal "Dashboard - PreBill", title
  end

  test "only services associated with the user will be displayed" do
    login_user "shoynoi.jp@gmail.com", "secret"
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

  test "display assist message when the user has not registered any service" do
    login_user "inactive@example.com", "secret"
    visit root_path
    assert_text "サービスを登録して、管理を始めましょう！"
  end
end
