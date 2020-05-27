# frozen_string_literal: true

require "factory_bot"

user = FactoryBot.create(:user, :activated, :accept_to_receive, name: "shoynoi", email: "shoynoi@example.com")
service = FactoryBot.create(:service, :renewal_today, :remind_today, name: "Sporify", user: user)
FactoryBot.create_list(:service, 10, user: user)
Notification.renew_service(service)
