# frozen_string_literal: true

namespace :notification do
  desc "Notify user to renewed service."
  task renewal: :environment do
    Service.includes(:user).renewal.group_by(&:user).each do |user, services|
      unless user.renewal_sent_at.try(:between?, Date.today.beginning_of_day, Date.today.end_of_day)
        services.each { |service| Notification.renew_service(service) }
        UserMailer.renew_service(user, services).deliver_now if user.mail_notification
        user.touch(:renewal_sent_at)
      end
    end
  end

  desc "Notify user to remind service."
  task remind: :environment do
    Service.remind.includes(:user).group_by(&:user).each do |user, services|
      unless user.remind_sent_at.try(:between?, Date.today.beginning_of_day, Date.today.end_of_day)
        UserMailer.remind_services(user, services).deliver_now
        user.touch(:remind_sent_at)
      end
    end
  end
end
