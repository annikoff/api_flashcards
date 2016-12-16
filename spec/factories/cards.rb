# frozen_string_literal: true
FactoryGirl.define do
  factory :card do
    original_text 'дом'
    translated_text 'house'
    user
    block
  end
end
