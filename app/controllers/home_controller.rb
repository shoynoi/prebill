# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @services = Service.all
  end
end
