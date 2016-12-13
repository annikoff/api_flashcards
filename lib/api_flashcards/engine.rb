# frozen_string_literal: true
module ApiFlashcards
  class Engine < ::Rails::Engine
    isolate_namespace ApiFlashcards
    config.generators.api_only = true
  end
end
