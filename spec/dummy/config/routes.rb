# frozen_string_literal: true
Rails.application.routes.draw do
  mount ApiFlashcards::Engine => '/api', as: 'api_flashcards'
end
