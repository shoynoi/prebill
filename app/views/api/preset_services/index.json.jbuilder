# frozen_string_literal: true

json.array! @preset_services do |preset_service|
  json.(preset_service, :name, :plan, :price)
end
