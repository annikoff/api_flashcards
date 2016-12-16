# frozen_string_literal: true
class Card < ApplicationRecord
  belongs_to :user
  belongs_to :block
  validate :texts_are_not_equal
  validates :user_id, :block_id, presence: true

  def check_translation(user_translation)
    case
    when user_translation == translated_text
      { state: true, distance: 0 }
    when user_translation =~ %r{#{translated_text}}
      { state: true, distance: 0.1 }
    else
      { state: false, distance: 2 }
    end
  end

  private

  def texts_are_not_equal
    return if original_text != translated_text
    errors.add :original_text, 'input values must be different'
  end
end
