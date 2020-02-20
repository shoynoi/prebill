class AddMessageToNotifications < ActiveRecord::Migration[6.0]
  def change
    add_column :notifications, :message, :string
  end
end
