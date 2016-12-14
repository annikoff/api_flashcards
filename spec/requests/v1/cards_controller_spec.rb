# frozen_string_literal: true
require 'spec_helper'

describe ApiFlashcards::V1::CardsController do
  let(:user) { create(:user_with_one_block_and_two_cards) }

  describe 'index' do
    it 'returns an array of cards' do
      get v1_cards_path, headers: http_authorization(user.email, user.password)
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['cards'].size).to eq(2)
    end
  end

  describe 'create' do
    let(:card) { build(:card, block: user.blocks.first, user: user) }

    it 'card with valid params' do
      post v1_cards_path,
           params: { card: card.attributes },
           headers: http_authorization(user.email, user.password)

      body = JSON.parse(response.body)['card']
      expect(response).to have_http_status(200)
      expect(body['original_text']).to eq(card.original_text)
      expect(body['translated_text']).to eq(card.translated_text)
    end

    it 'card with missing params' do
      post v1_cards_path,
           params: { card: {} },
           headers: http_authorization(user.email, user.password)

      expect(response).to have_http_status(400)
      expect(response.body).to match('Bad Request')
    end

    it 'card with invalid block' do
      card.block_id = nil
      post v1_cards_path,
           params: { card: card.attributes },
           headers: http_authorization(user.email, user.password)

      expect(response).to have_http_status(404)
      expect(response.body).to match('Not Found')
    end

    it 'card with invalid parameters' do
      card.translated_text = card.original_text
      post v1_cards_path,
           params: { card: card.attributes },
           headers: http_authorization(user.email, user.password)

      expect(response).to have_http_status(422)
      expect(response.body).to match('Unprocessable Entity')
    end
  end
end
