# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    association :service
    read { false }
    message { "テストサービスが更新されました。" }

    trait :notify_today do
      created_at { Date.today }
    end

    trait :notify_yesterday do
      created_at { Date.yesterday }
    end

    trait :notify_day_before_yesterday do
      created_at { Date.today - 2 }
    end

    trait :already_read do
      read { true }
    end
  end
end
