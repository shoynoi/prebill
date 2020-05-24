# frozen_string_literal: true

FactoryBot.define do
  factory :service do
    name { "Spotify" }
    description { "https://www.spotify.com/jp/\n解約予定" }
    plan { 0 }
    price { 980 }
    association :user
  end
end
