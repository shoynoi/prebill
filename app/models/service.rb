# frozen_string_literal: true

class Service < ApplicationRecord
  enum plan: { monthly: 0, yearly: 1 }

  belongs_to :user

  validates :name, presence: true
  validates :plan, presence: true
  validates :price, numericality: { only_integer: true, allow_blank: true }

  def self.annual_total_amount
    total_amount("yearly") + (total_amount("monthly") * 12)
  end

  def self.monthly_average_amount
    annual_total_amount / 12
  end

  private
    def self.total_amount(plan)
      where(plan: plan).sum(:price)
    end
end
