# frozen_string_literal: true

json.array! @notifications do |notification|
  json.id notification.id
  json.read notification.read
  json.message notification.message
  json.created_at time_ago_in_words notification.created_at
end
