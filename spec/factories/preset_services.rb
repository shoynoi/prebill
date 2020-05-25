# frozen_string_literal: true

FactoryBot.define do
  factory :preset_service do
    name { "Hulu" }
    plan { 0 }
    price { 1026 }
  end
end
