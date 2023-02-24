# frozen_string_literal: true

class CreateSpendings < ActiveRecord::Migration[7.0]
  def up
    create_table :spendings do |t|
      t.string :title
      t.decimal :amount, precision: 16, scale: 2
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.references :category, foreign_key: true

      t.timestamps
    end
  end

  def down
    remove_foreign_key :users, :spendings
    remove_foreign_key :categories, :spendings
    drop_table :spendings
  end
end
