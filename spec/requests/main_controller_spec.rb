# frozen_string_literal: true
require 'spec_helper'

describe ApiFlashcards::MainController do
  describe 'index' do
    let(:user) { User.create(email: 'test@test.ru', password: '123') }

    it 'require basic authentication' do
      get root_path
      expect(response).to have_http_status(401)
    end

    it 'authenticate user with failed' do
      get root_path, headers: http_authorization(user.email, '321')
      expect(response).to have_http_status(401)
      expect(response.body).to match('HTTP Basic: Access denied.')
    end

    it 'authenticate user with success' do
      get root_path, headers: http_authorization(user.email, user.password)
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq { 'success' => true }
    end
  end
end
