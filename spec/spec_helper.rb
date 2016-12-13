# frozen_string_literal: true
require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/config/'
  add_filter '/bin/'
end

RSpec.configure do |config|
end
