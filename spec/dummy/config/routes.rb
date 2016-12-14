# frozen_string_literal: true
Rails.application.routes.draw do
  mount ApiFlashcards::Engine => '/api_flashcards', as: 'api_flashcards'
end
