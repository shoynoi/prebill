# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :service

  scope :recent, -> { order(created_at: :desc).limit(5) }
end
