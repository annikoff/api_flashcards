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
    let(:another_user) { create(:user_with_one_block) }
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

      errors = JSON.parse(response.body)['errors']
      expect(response).to have_http_status(400)
      expect(errors.first)
        .to eq('param is missing or the value is empty: card')
    end

    it 'card with invalid block' do
      card.block_id = 9999
      post v1_cards_path,
           params: { card: card.attributes },
           headers: http_authorization(user.email, user.password)

      errors = JSON.parse(response.body)['errors']
      expect(response).to have_http_status(404)
      expect(errors.first).to eq('Couldn\'t find Block with \'id\'=9999')
    end

    it 'card with invalid parameters' do
      card.translated_text = card.original_text
      post v1_cards_path,
           params: { card: card.attributes },
           headers: http_authorization(user.email, user.password)

      errors = JSON.parse(response.body)['errors']
      expect(response).to have_http_status(422)
      expect(errors.first).to eq('Original text input values must be different')
    end

    it 'card with block of another user' do
      another_block = another_user.blocks.first
      card.block_id = another_block.id
      post v1_cards_path,
           params: { card: card.attributes },
           headers: http_authorization(user.email, user.password)
      errors = JSON.parse(response.body)['errors']
      expect(response).to have_http_status(403)
      expect(errors.first).to eq I18n.t('global.alerts.not_authorized')
    end
  end

  describe 'review' do
    let(:another_user) { create(:user_with_one_block_and_one_card) }
    let(:card) { user.cards.first }

    it 'card of another user' do
      card = another_user.cards.first
      put review_v1_card_path(id: card.id),
          params: { card: card.attributes },
          headers: http_authorization(user.email, user.password)

      errors = JSON.parse(response.body)['errors']
      expect(response).to have_http_status(403)
      expect(errors.first).to eq I18n.t('global.alerts.not_authorized')
    end

    it 'card with invalid id' do
      put review_v1_card_path(id: 9999),
          params: { card: card.attributes },
          headers: http_authorization(user.email, user.password)

      errors = JSON.parse(response.body)['errors']
      expect(response).to have_http_status(404)
      expect(errors.first).to eq('Couldn\'t find Card with \'id\'=9999')
    end

    it 'card with correct translation' do
      params = { user_translation: card.translated_text }
      put review_v1_card_path(id: card.id),
          params: { card: params },
          headers: http_authorization(user.email, user.password)

      body = JSON.parse(response.body)['card']
      expect(response).to have_http_status(200)
      expect(body['original_text']).to eq(card.original_text)
      expect(body['translated_text']).to eq(card.translated_text)
    end

    it 'card with misprint translation' do
      params = { user_translation: "#{card.translated_text}typo" }
      put review_v1_card_path(id: card.id),
          params: { card: params },
          headers: http_authorization(user.email, user.password)

      errors = JSON.parse(response.body)['errors']
      expect(response).to have_http_status(422)
      expect(errors.first).to match('You entered translation from misprint')
    end

    it 'card with incorrect translation' do
      params = { user_translation: 'blah' }
      put review_v1_card_path(id: card.id),
          params: { card: params },
          headers: http_authorization(user.email, user.password)

      errors = JSON.parse(response.body)['errors']
      expect(response).to have_http_status(422)
      expect(errors.first).to eq I18n.t('global.alerts.incorrect_translation')
    end
  end
end
