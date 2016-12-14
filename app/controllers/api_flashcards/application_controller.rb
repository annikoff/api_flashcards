# frozen_string_literal: true
module ApiFlashcards
  class ApplicationController < ActionController::API
    include ActionController::HttpAuthentication::Basic::ControllerMethods
    before_action :authenticate

    private

    def authenticate
      @user = authenticate_with_http_basic { |u, p| User.authenticate(u, p) }
      request_http_basic_authentication unless @user
    end
  end
end
