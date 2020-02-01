# frozen_string_literal: true

class Service < ApplicationRecord
  enum plan: { monthly: 0, yearly: 1 }

  belongs_to :user

  validates :name, presence: true
  validates :plan, presence: true
  validates :price, numericality: { only_integer: true, allow_blank: true }

  scope :renewal, -> { where(renewed_on: Date.today) }
  scope :notice, -> { where(remind_on: Date.today) }

  def self.annual_total_amount
    total_amount("yearly") + (total_amount("monthly") * 12)
  end

  def self.monthly_average_amount
    annual_total_amount / 12
  end

  def renew!
    case plan
    when "yearly"
      update!(renewed_on: renewed_on.next_year)
    when "monthly"
      update!(renewed_on: renewed_on.next_month)
    end
  end

  private
    def self.total_amount(plan)
      where(plan: plan).sum(:price)
    end
end
