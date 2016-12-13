# frozen_string_literal: true
module AuthHelper
  def http_authorization(email, password)
    credentials = ActionController::HttpAuthentication::Basic
                  .encode_credentials(email, password)
    { 'HTTP_AUTHORIZATION' => credentials }
  end
end
