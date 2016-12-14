# frozen_string_literal: true
class User < ApplicationRecord
  def self.authenticate(email, password)
    find_by email: email, password: password
  end
end
