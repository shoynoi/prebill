# frozen_string_literal: true

class SorceryCore < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :crypted_password
      t.string :salt

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
  end
end
