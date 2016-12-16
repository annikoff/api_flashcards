# frozen_string_literal: true
FactoryGirl.define do
  factory :block do
    sequence(:title) { |n| "Block #{n}" }
    user

    factory :block_with_one_cards do
      after(:create) do |block|
        create(:card, user: block.user, block: block)
      end
    end

    factory :block_with_two_cards do
      after(:create) do |block|
        create(:card, user: block.user, block: block)
        create(:card, user: block.user, block: block)
      end
    end
  end
end
