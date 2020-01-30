# frozen_string_literal: true

require "test_helper"

class ServiceTest < ActiveSupport::TestCase
  test "is valid" do
    service = services(:spotify)
    assert service.valid?
  end

  test "is invalid when name is blank" do
    service = services(:spotify)
    service.name = ""
    assert service.invalid?
  end

  test "is invalid when plan is blank" do
    service = services(:spotify)
    service.plan = ""
    assert service.invalid?
  end

  test "is invalid when price is not Integer" do
    service = services(:spotify)
    service.price = "980円"
    assert service.invalid?
  end

  test "is valid when price is blank" do
    service = services(:spotify)
    service.price = ""
    assert service.valid?
  end

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

  test "renew!" do
    user = users(:shoynoi)
    monthly_service = Service.create(name: "Monthly Subscription", plan: "monthly", renewed_on: Date.today, user: user)
    yearly_service = Service.create(name: "Yearly Subscription", plan: "yearly", renewed_on: Date.today, user: user)
    assert_changes -> { monthly_service.renewed_on }, from: Date.today, to: Date.today.next_month do
      monthly_service.renew!
    end
    assert_changes -> { yearly_service.renewed_on }, from: Date.today, to: Date.today.next_year do
      yearly_service.renew!
    end
  end

  test "renewal" do
    renewal_services = services(:renewal, :other_renewal)
    travel_to Time.zone.parse("2020-01-31") do
      assert_equal Service.renewal, renewal_services
    end
  end
end
