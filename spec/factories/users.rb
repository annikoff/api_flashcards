# frozen_string_literal: true
FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@test.ru" }
    password '123'

    factory :user_with_one_block do
      after(:create) do |user|
        create(:block, user: user)
      end
    end

    factory :user_with_one_block_and_one_card do
      after(:create) do |user|
        create(:block_with_one_cards, user: user)
      end
    end

    factory :user_with_one_block_and_two_cards do
      after(:create) do |user|
        create(:block_with_two_cards, user: user)
      end
    end
  end
end
