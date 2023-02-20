# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string           not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # - Devise - #
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  # - Relationships - #
  has_many :categories, dependent: :destroy

  # - Validations - #
  validates :name, presence: true

  # - Callbacks - #
  after_create :create_default_categories

  private

  def create_default_categories
    %w[Traveling Clothing Taxi Cafes Shops Other].each do |name|
      categories.create(name:)
    end
  end
end
