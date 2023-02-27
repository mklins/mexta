# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  share_link             :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

RSpec.describe User do
  describe 'Relations' do
    it { is_expected.to have_many(:categories).dependent(:destroy) }
    it { is_expected.to have_many(:spendings).dependent(:destroy) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
  end

  describe 'Callbacks' do
    let(:user) { build(:user) }

    it 'creates default pack of categories after user creation' do
      expect { user.save }.to change(Category, :count).by(6)

      expect(user.categories.pluck(:name)).to contain_exactly(
        'Traveling', 'Clothing', 'Taxi', 'Cafes', 'Shops', 'Other'
      )
    end
  end
end
