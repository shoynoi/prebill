# frozen_string_literal: true

require "test_helper"

class ServiceTest < ActiveSupport::TestCase
  test "when destroy a user, destroy services associated with a user" do
    user = User.create!(name: "johndoe", email: "test@example.com", password: "secret", password_confirmation: "secret")
    user.services.create!(name: "test service")
    assert_difference "user.services.count", -1 do
      user.destroy
    end
  end

  test "annual_total_amount" do
    user = users(:inactive)
    Service.create(name: "Spotify", plan: "monthly", price: 980, user: user)
    Service.create(name: "Rubymine", plan: "yearly", price: 8000, user: user)
    assert_equal 19760, user.services.annual_total_amount
  end

  test "monthly_average_amount" do
    user = users(:inactive)
    Service.create(name: "Spotify", plan: "monthly", price: 980, user: user)
    Service.create(name: "Rubymine", plan: "yearly", price: 8000, user: user)
    assert_equal 1646, user.services.monthly_average_amount
  end

  test "renewal" do
    renewal_services = services(:renewal, :other_renewal)
    travel_to Time.zone.parse("2020-01-31") do
      assert_equal renewal_services, Service.renewal
    end
  end

  test "#next_renewed_on of every month" do
    user = users(:shoynoi)
    service = user.services.create(name: "monthly update", plan: 0, renewed_on: Date.parse("2020-10-29"), user: user)
    travel_to Time.zone.parse("2020-10-29") do
      assert_equal Date.parse("2020-10-29"), service.next_renewed_on
    end
    travel_to Time.zone.parse("2020-10-30") do
      assert_equal Date.parse("2020-11-29"), service.next_renewed_on
    end
    travel_to Time.zone.parse("2020-11-30") do
      assert_equal Date.parse("2020-12-29"), service.next_renewed_on
    end
  end

  test "#next_renewed_on of every year" do
    user = users(:shoynoi)
    service = user.services.create(name: "yearly update", plan: 1, renewed_on: Date.parse("2020-02-29"), user: user)
    travel_to Time.zone.parse("2020-02-29") do
      assert_equal Date.parse("2020-02-29"), service.next_renewed_on
    end
    travel_to Time.zone.parse("2020-03-01") do
      assert_equal Date.parse("2021-02-28"), service.next_renewed_on
    end
    travel_to Time.zone.parse("2023-03-01") do
      assert_equal Date.parse("2024-02-29"), service.next_renewed_on
    end
  end

  test "#next_renewed_on of every end of month" do
    service = services(:renewal)
    travel_to Time.zone.parse("2020-01-31") do
      assert_equal Date.parse("2020-01-31"), service.next_renewed_on
    end
    travel_to Time.zone.parse("2020-02-01") do
      assert_equal Date.parse("2020-02-29"), service.next_renewed_on
    end
    travel_to Time.zone.parse("2020-03-01") do
      assert_equal Date.parse("2020-03-31"), service.next_renewed_on
    end
  end
end
