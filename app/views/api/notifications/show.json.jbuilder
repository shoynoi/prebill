# frozen_string_literal: true

json.(@notification, :read, :created_at)
json.service do
  json.renewed_on @notification.service.renewed_on
end
