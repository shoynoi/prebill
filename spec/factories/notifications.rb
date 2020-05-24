# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    association :service, renewed_on: Date.today
    read { false }
    message { "テストサービスが更新されました。" }
  end
end
