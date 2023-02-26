# frozen_string_literal: true

# == Schema Information
#
# Table name: spendings
#
#  id          :bigint           not null, primary key
#  amount      :decimal(16, 2)
#  description :text
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint
#  user_id     :bigint           not null
#
# Indexes
#
#  index_spendings_on_amount       (amount)
#  index_spendings_on_category_id  (category_id)
#  index_spendings_on_description  (description)
#  index_spendings_on_title        (title)
#  index_spendings_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (user_id => users.id)
#
class Spending < ApplicationRecord
  # - Relationships - #
  belongs_to :user, optional: false
  belongs_to :category, optional: true

  # - Validations - #
  validates :title, :amount, presence: true
  validates :amount, numericality: { greater_than: 0 }

  def self.ransackable_attributes(_auth_object = nil)
    %w[amount description title category_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[category]
  end
end
