# frozen_string_literal: true

require "test_helper"

class NotificationTest < ActiveSupport::TestCase
  setup do
    @monthly = services(:renewal)
    @yearly = services(:other_renewal)
    Prebill::Application.load_tasks
    Rake::Task["notification:renewal"].execute
  end

  test "renew service" do
    assert_equal Date.today.next_month, @monthly.reload.renewed_on
    assert_equal Date.today.next_year, @yearly.reload.renewed_on
    assert_equal ActionMailer::Base.deliveries.count, 2
  end
end
