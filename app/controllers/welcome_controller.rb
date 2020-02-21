# frozen_string_literal: true

class WelcomeController < ApplicationController
  skip_before_action :require_login

  def tos
  end

  def policy
  end
end
