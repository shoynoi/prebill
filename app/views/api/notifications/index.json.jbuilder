# frozen_string_literal: true

json.array! @notifications do |notification|
  json.(notification, :id, :read, :created_at)
  json.service do
    json.name notification.service.name
    json.renewed_on notification.service.renewed_on
  end
end
