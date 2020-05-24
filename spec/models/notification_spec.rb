# frozen_string_literal: true

require "rails_helper"

RSpec.describe Notification, type: :model do
  let(:user) { create(:user) }

  describe "renew_service" do
    let(:notified_service) { create(:service, renewed_on: Date.today, user: user) }
    it "create notification" do
      expect {
        Notification.renew_service(notified_service)
      }.to change(Notification, :count).by(1)
    end
  end

  describe "recent" do
    let(:service) { create(:service, user: user) }
    let(:notification1) { create(:notification, service: service, created_at: Date.today - 2) }
    let(:notification2) { create(:notification, service: service, created_at: Date.yesterday) }
    let(:notification3) { create(:notification, service: service, created_at: Date.today) }

    it "returns recent notifications by descending order" do
      expect(Notification.recent).to match([notification3, notification2, notification1])
    end
  end

  describe "unread" do
    let(:service) { create(:service, user: user) }
    let(:read_notification) { create(:notification, service: service, read: true) }
    let(:unread_notification) { create(:notification, service: service, read: false) }

    it "returns unread notification" do
      expect(Notification.unread).to match([unread_notification])
      expect(Notification.unread).to_not match([read_notification])
    end
  end
end
