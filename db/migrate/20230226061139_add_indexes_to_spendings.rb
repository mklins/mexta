# frozen_string_literal: true

class AddIndexesToSpendings < ActiveRecord::Migration[7.0]
  def up
    add_index :spendings, :amount
    add_index :spendings, :description
    add_index :spendings, :title
  end

  def down
    remove_index :spendings, :amount
    remove_index :spendings, :description
    remove_index :spendings, :title
  end
end
