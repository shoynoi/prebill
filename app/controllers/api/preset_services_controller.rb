# frozen_string_literal: true

class Api::PresetServicesController < ApplicationController
  def index
    @preset_services = PresetService.all
  end
end
