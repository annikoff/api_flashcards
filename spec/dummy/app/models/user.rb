# frozen_string_literal: true
class User < ApplicationRecord
  has_many :blocks
  has_many :cards

  def self.authenticate(email, password)
    find_by email: email, password: password
  end
end
