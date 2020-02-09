# frozen_string_literal: true

class Service < ApplicationRecord
  enum plan: { monthly: 0, yearly: 1 }

  belongs_to :user
  has_many :notifications

  validates :name, presence: true
  validates :plan, presence: true
  validates :price, numericality: { only_integer: true, allow_blank: true }

  scope :remind, -> { where(remind_on: Date.today) }

  def self.annual_total_amount
    total_amount("yearly") + (total_amount("monthly") * 12)
  end

  def self.monthly_average_amount
    annual_total_amount / 12
  end

  def self.renewal
    Service.select { |service| service.next_renewed_on == Date.today }
  end

  def next_renewed_on(n = 0)
    case plan
    when "monthly"
      renewed_on.next_month(number_of_renewal + n)
    when "yearly"
      renewed_on.next_year(number_of_renewal + n)
    end
  end

  private
    def self.total_amount(plan)
      where(plan: plan).sum(:price)
    end

    def elapsed_months
      today = Date.today
      return 0 if today <= renewed_on
      elapsed_months = (today.year - renewed_on.year) * 12 + (today.month - renewed_on.month) + 1
      if renewed_on.day < today.day || today.day == Time.days_in_month(today.month) && today.day < renewed_on.day
        elapsed_months
      else
        elapsed_months - 1
      end
    end

    def elapsed_years
      today = Date.today
      return 0 if today <= renewed_on
      elapsed_months / 12 + 1
    end

    def number_of_renewal
      case plan
      when "monthly"
        elapsed_months
      when "yearly"
        elapsed_years
      end
    end
end
