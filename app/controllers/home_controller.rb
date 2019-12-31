class HomeController < ApplicationController
  def index
    @services = Service.all
  end
end
