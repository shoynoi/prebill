# frozen_string_literal: true

class Api::NotificationsController < ApplicationController
  def show
    @notification = Notification.find_by(id: params[:id])
    render json: @notification
  end

  def update
    @notification = current_user.notifications.find_by(id: params[:id])
    @notification.update(read: true)
  end
end
