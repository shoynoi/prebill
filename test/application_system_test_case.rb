# frozen_string_literal: true

require "test_helper"
require "supports/login_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include LoginHelper
  driven_by :selenium, using: :headless_chrome
end
