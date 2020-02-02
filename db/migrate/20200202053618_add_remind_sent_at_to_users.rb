# frozen_string_literal: true

class AddRemindSentAtToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :remind_sent_at, :datetime
    add_index :users, :remind_sent_at
  end
end
