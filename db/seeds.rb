# frozen_string_literal: true

require "csv"

case Rails.env
when "production"
  CSV.foreach("db/preset_services.csv", headers: true) do |row|
    PresetService.find_or_create_by!(
      name: row["name"],
      plan: row["plan"],
      price: row["price"]
      )
  end
when "development"
  load(Rails.root.join("db/seeds/development.rb"))
end
