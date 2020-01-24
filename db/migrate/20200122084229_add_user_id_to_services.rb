# frozen_string_literal: true

class AddUserIdToServices < ActiveRecord::Migration[6.0]
  def up
    execute "DELETE FROM services;"
    add_reference :services, :user, null: false, foreign_key: true, index: true
  end

  def down
    remove_reference :services, :user, index: true
  end
end
