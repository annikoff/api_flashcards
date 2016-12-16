# frozen_string_literal: true
class Block < ApplicationRecord
  belongs_to :user
  has_many :cards
end
