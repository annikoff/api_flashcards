# frozen_string_literal: true
class Card < ApplicationRecord
  belongs_to :user
  belongs_to :block
  validate :texts_are_not_equal
  validates :user_id, :block_id, presence: true

  private

  def texts_are_not_equal
    return if original_text != translated_text
    errors.add :original_text, 'input values must be different'
  end
end
