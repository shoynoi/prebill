# frozen_string_literal: true

namespace :notification do
  desc "Notify user to renewed service."
  task renewal: :environment do
    Service.renewal.includes(:user).group_by(&:user).each do |user, services|
      services.each(&:renew!)
      UserMailer.renew_service(user, services).deliver_now
    end
  end
end
