# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:name) { Faker::Name.name }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { SecureRandom.hex(10) }
  end
end
