require 'test_helper'

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
end
