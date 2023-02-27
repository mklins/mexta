# frozen_string_literal: true

class AddShareLinkToUsers < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :share_link, :string
  end

  def down
    remove_column :users, :share_link
  end
end
