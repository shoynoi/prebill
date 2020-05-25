# frozen_string_literal: true

module LoginHelper
  def login_user(email, password)
    visit "/login"
    fill_in "user[email]", with: email
    fill_in "user[password]", with: password
    click_button "ログイン"
  end

  def logout
    visit "/logout"
  end
end

RSpec.configure do |config|
  config.include LoginHelper, type: :feature
end
