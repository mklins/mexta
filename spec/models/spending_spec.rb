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
require 'rails_helper'

RSpec.describe Spending do
  describe 'Relations' do
    it { is_expected.to belong_to(:user).required }
    it { is_expected.to belong_to(:category).required(false) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }
  end
end
