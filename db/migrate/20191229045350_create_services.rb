class CreateServices < ActiveRecord::Migration[6.0]
  def change
    create_table :services do |t|
      t.string :name, null: false
      t.text :description
      t.integer :plan, default: 0, null: false
      t.integer :price
      t.date :renewed_on
      t.date :notified_on

      t.timestamps
    end
  end
end
