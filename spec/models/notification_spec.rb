# frozen_string_literal: true

require "rails_helper"

RSpec.describe Notification, type: :model do
  describe "renew_service" do
    let(:notified_service) { create(:service, renewed_on: Date.today) }
    it "create notification" do
      expect {
        Notification.renew_service(notified_service)
      }.to change(Notification, :count).by(1)
    end
  end

  describe "recent" do
    let(:notify_day_before_yesterday) { create(:notification, :notify_day_before_yesterday) }
    let(:notify_yesterday) { create(:notification, :notify_yesterday) }
    let(:notify_today) { create(:notification, :notify_today) }

    it "returns recent notifications by created_at descending order" do
      expect(Notification.recent).to match([notify_today, notify_yesterday, notify_day_before_yesterday])
    end
  end

  describe "unread" do
    let(:unread_notification) { create(:notification) }
    let(:read_notification) { create(:notification, :already_read) }

    it "returns unread notification" do
      expect(Notification.unread).to match([unread_notification])
      expect(Notification.unread).to_not match([read_notification])
    end
  end
end
