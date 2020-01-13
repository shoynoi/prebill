# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :require_login

  def index
    if current_user
      @services = Service.all
    else
      render "welcome/index", layout: "welcome"
    end
  end
end
