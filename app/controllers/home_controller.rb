# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :require_login

  def index
    if logged_in?
      @services = current_user.services.all
    else
      render "welcome/index", layout: "welcome"
    end
  end
end
