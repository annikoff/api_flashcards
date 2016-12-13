# frozen_string_literal: true
module ApiFlashcards
  class MainController < ApplicationController
    def index
      render json: { success: true }
    end
  end
end
