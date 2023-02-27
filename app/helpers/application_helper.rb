# frozen_string_literal: true

module ApplicationHelper
  def show_header?
    true if controller_name == 'spendings' || controller_name == 'categories'
  end
end
