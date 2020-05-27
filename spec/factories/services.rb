# frozen_string_literal: true

FactoryBot.define do
  factory :service do
    sequence(:name) { |n| "Service Name-#{n}" }
    description { "description..." }
    plan { 0 }
    price { 980 }
    association :user

    trait :plan_yearly do
      plan { 1 }
    end

    trait :remind_today do
      remind_on { Date.today }
    end

    trait :remind_yesterday do
      remind_on { Date.yesterday }
    end

    trait :remind_tomorrow do
      remind_on { Date.tomorrow }
    end

    trait :renewal_today do
      renewed_on { Date.today }
    end

    trait :renewal_yesterday do
      renewed_on { Date.yesterday }
    end

    trait :renewal_tomorrow do
      renewed_on { Date.tomorrow }
    end
  end
end
