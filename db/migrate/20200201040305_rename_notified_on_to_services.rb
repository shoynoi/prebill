# frozen_string_literal: true

class RenameNotifiedOnToServices < ActiveRecord::Migration[6.0]
  def change
    rename_column :services, :notified_on, :remind_on
  end
end
