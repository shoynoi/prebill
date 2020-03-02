# frozen_string_literal: true

class RemoveNotNullConstraintFromPresetServices < ActiveRecord::Migration[6.0]
  def up
    change_column_null :preset_services, :plan, true
    change_column_null :preset_services, :price, true
  end

  def down
    change_column_null :preset_services, :plan, false
    change_column_null :preset_services, :price, false
  end
end
