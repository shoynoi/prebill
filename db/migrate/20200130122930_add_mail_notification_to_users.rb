class AddMailNotificationToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :mail_notification, :boolean, default: false, null: false
  end
end
