# frozen_string_literal: true

class AddRenewalSentAtToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :renewal_sent_at, :datetime
    add_index :users, :renewal_sent_at
  end
end
