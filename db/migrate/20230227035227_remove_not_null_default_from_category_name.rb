# frozen_string_literal: true

class RemoveNotNullDefaultFromCategoryName < ActiveRecord::Migration[7.0]
  def up
    change_column :categories, :name, :string, null: true, default: nil
  end

  def down
    change_column :categories, :name, :string, null: false, default: 'Other'
  end
end
