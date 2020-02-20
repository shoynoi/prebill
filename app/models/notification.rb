# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :service

  scope :recent, -> { order(created_at: :desc).limit(5) }
  scope :unread, -> { where(read: false) }
end
