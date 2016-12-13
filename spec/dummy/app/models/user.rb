# frozen_string_literal: true
class User < ApplicationRecord
  def self.authenticate(email, password)
    where(email: email, password: password).first
  end
end
