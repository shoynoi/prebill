# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :require_login

  def index
    @services = Service.all
  end
end
