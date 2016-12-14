# frozen_string_literal: true
ApiFlashcards::Engine.routes.draw do
  root to: 'main#index'

  namespace :v1, defaults: { format: :json } do
    resources :cards, only: [:index, :create, :review] do
      post :review, on: :member
    end
  end
end
