# frozen_string_literal: true

class Service < ApplicationRecord
  enum plan: { monthly: 0, yearly: 1 }

  validates :name, presence: true
  validates :plan, presence: true
  validates :price, numericality: { only_integer: true, allow_blank: true }
end
