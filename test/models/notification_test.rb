# frozen_string_literal: true

require "test_helper"

class NotificationTest < ActiveSupport::TestCase
  test ".renew_service" do
    service = services(:spotify)
    assert_difference "Notification.count", 1 do
      Notification.renew_service(service)
    end
  end
end
