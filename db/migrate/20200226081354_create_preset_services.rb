# frozen_string_literal: true

class CreatePresetServices < ActiveRecord::Migration[6.0]
  def change
    create_table :preset_services do |t|
      t.string :name, null: false, comment: "名前"
      t.integer :plan, null: false, comment: "プラン"
      t.integer :price, null: false, comment: "料金"

      t.timestamps
    end
    add_index(:preset_services, :name, unique: true)
  end
end
