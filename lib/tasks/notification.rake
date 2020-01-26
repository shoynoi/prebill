# frozen_string_literal: true

namespace :notification do
  desc "Notify user to renewed service."
  task renewal: :environment do
    services = Service.renewal
    users = services.map(&:user).uniq
    services.each do |service|
      service.renew!
    end
    users.each do |user|
      UserMailer.renew_service(user)
    end
  end
end
