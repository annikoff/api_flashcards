# frozen_string_literal: true
require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require 'api_flashcards'

module Dummy
  class Application < Rails::Application
    config.cache_classes = true
    config.eager_load = false
    config.api_only = true
  end
end
