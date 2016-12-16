# frozen_string_literal: true
require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/config/'
  add_filter '/bin/'
end
ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../dummy/config/environment.rb', __FILE__)
require 'rspec/rails'
require 'factory_girl_rails'
require 'support/auth_helper'
include AuthHelper

Rails.backtrace_cleaner.remove_silencers!

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include ApiFlashcards::Engine.routes.url_helpers
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.order = 'random'
end
