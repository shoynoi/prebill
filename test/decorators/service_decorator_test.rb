# frozen_string_literal: true

require "test_helper"

class ServiceDecoratorTest < ActiveSupport::TestCase
  def setup
    @service = ActiveDecorator::Decorator.instance.decorate(services(:rubymine))
  end

  test "format_date" do
    travel_to Time.zone.local(2020, 12, 31) do
      assert_equal "2021年01月25日", @service.formatted_renewed_on
      assert_equal "12月31日", @service.formatted_notified_on
    end
  end
end
