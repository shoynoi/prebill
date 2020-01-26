# frozen_string_literal: true

require 'test_helper'

class ServiceDecoratorTest < ActiveSupport::TestCase
  def setup
    @service = Service.new.extend ServiceDecorator
  end

  # test "the truth" do
  #   assert true
  # end
end
