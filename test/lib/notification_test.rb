# frozen_string_literal: true

require "test_helper"

class NotificationTest < ActiveSupport::TestCase
  setup do
    ActionMailer::Base.deliveries.clear
    Prebill::Application.load_tasks
  end

  test "renew service" do
    travel_to Time.zone.parse("2020-01-31") do
      Rake::Task["notification:renewal"].execute
      assert_equal ActionMailer::Base.deliveries.count, 2
    end
  end

  test "do not send mail if user do not want to receive" do
    user = users(:inactive)
    user.services.create(name: "No notification", plan: 0, renewed_on: "2020-10-10")
    travel_to Time.zone.parse("2020-10-10") do
      Rake::Task["notification:renewal"].execute
      assert_equal ActionMailer::Base.deliveries.count, 0
    end
  end

  test "remind services" do
    travel_to Time.zone.parse("2020-12-31") do
      Rake::Task["notification:remind"].execute
      assert_equal ActionMailer::Base.deliveries.count, 1
    end
  end

  test "do not send emails to reminded users" do
    travel_to Time.zone.parse("2020-12-31") do
      Rake::Task["notification:remind"].execute
      assert_equal ActionMailer::Base.deliveries.count, 1
      ActionMailer::Base.deliveries.clear
      Rake::Task["notification:remind"].execute
      assert_equal ActionMailer::Base.deliveries.count, 0
    end
  end
end
