# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :service

  scope :recent, -> { order(created_at: :desc).limit(5) }
  scope :unread, -> { where(read: false) }

  def self.renew_service(service)
    Notification.create!(
      service: service,
      read: false,
      message: "#{service.name}が更新されました。次回の更新日は#{I18n.l service.next_renewed_on(1)}です。"
    )
  end
end
