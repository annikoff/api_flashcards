# frozen_string_literal: true
module ApiFlashcards
  class MainController < ApplicationController
    rescue_from StandardError do |exception|
      status_code = ActionDispatch::ExceptionWrapper
                    .new(request, exception).status_code
      render_error status_code, exception
    end

    def index
      render json: { success: true }
    end

    protected

    def render_error(status, errors)
      render status: status, json: { errors: Array(errors) }
      false
    end
  end
end
