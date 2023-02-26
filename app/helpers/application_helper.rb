# frozen_string_literal: true

module ApplicationHelper
  def show_header?
    true if current_page?(spendings_path) || current_page?(categories_path)
  end
end
