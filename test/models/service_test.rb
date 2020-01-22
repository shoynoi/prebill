# frozen_string_literal: true

require "test_helper"

class ServiceTest < ActiveSupport::TestCase
  test "is valid" do
    service = services(:service_1)
    assert service.valid?
  end

  test "is invalid when name is blank" do
    service = services(:service_1)
    service.name = ""
    assert service.invalid?
  end

  test "is invalid when plan is blank" do
    service = services(:service_1)
    service.plan = ""
    assert service.invalid?
  end

  test "is invalid when price is not Integer" do
    service = services(:service_1)
    service.price = "980円"
    assert service.invalid?
  end

  test "is valid when price is blank" do
    service = services(:service_1)
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
end
