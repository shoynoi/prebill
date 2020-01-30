# frozen_string_literal: true

require "test_helper"

class NotificationTest < ActiveSupport::TestCase
  setup do
    Prebill::Application.load_tasks
  end

  test "renew service" do
    monthly = services(:renewal)
    yearly = services(:other_renewal)
    travel_to Time.zone.parse("2020-01-31") do
      Rake::Task["notification:renewal"].execute
      assert_equal Date.parse("2020-02-29"), monthly.reload.renewed_on
      assert_equal Date.parse("2021-01-31"), yearly.reload.renewed_on
      assert_equal ActionMailer::Base.deliveries.count, 2
    end
  end

  test "do not send mail if user do not want to receive" do
    user = users(:inactive)
    service = user.services.create(name: "No notification", plan: 0, renewed_on: "2020-10-10")
    travel_to Time.zone.parse("2020-10-10") do
      Rake::Task["notification:renewal"].execute
      assert_equal Date.parse("2020-11-10"), service.reload.renewed_on
      assert_equal ActionMailer::Base.deliveries.count, 0
    end
  end
end
