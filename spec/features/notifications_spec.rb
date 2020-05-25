# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Notifications", type: :feature do
  let!(:user) { create(:user, :activated, email: "tester@exmaple.com") }

  context "when nothing notification" do
    scenario "display message when no notifications" do
      login_user "tester@exmaple.com", "secret"
      find(".header-notification__label").click
      within(".header-dropdown__container") do
        expect(page).to have_content "通知はありません"
      end
    end
  end

  context "when any notifications", js: true do
    let(:service) { create(:service, user: user, name: "Notified Service") }
    let!(:notification) { create(:notification, service: service) }

    scenario "display notification" do
      login_user "tester@exmaple.com", "secret"
      find(".header-notification__label").click
      within(".header-dropdown__container") do
        expect(page).to have_content "Notified Serviceが更新されました。"
      end
    end

    scenario "click notification to already read", js: true do
      login_user "tester@exmaple.com", "secret"
      find(".header-notification__label").click
      find(".header-dropdown__item").click
      sleep 0.1
      expect(notification.reload).to be_read
      within(".header-dropdown__container") do
        expect(page).to have_css(".is-read", visible: :all)
      end
    end
  end
end
