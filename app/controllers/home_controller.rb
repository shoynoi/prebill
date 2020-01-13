# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :require_login

  def index
    if logged_in?
      @services = Service.all
    else
      render "welcome/index", layout: "welcome"
    end
  end
end
