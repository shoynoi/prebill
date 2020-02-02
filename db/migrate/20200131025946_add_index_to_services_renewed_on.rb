# frozen_string_literal: true

class AddIndexToServicesRenewedOn < ActiveRecord::Migration[6.0]
  def change
    add_index :services, :renewed_on
  end
end
