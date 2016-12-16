# frozen_string_literal: true
module ApiFlashcards
  module V1
    class CardsController < ApiFlashcards::MainController
      before_action :find_card, only: [:review]
      before_action :find_block, only: [:create]
      before_action :check_access, only: [:review, :create]

      # = GET /api/v1/cards.json
      # Returns an array of user's cards.
      #
      # @example Request:
      #     curl http://<host>/api/v1/cards -u login:password'
      #
      # @return [JSON]
      def index
        @cards = @user.cards
        render json: { cards: @cards }
      end

      # = POST /api/v1/cards.json
      # Create a card.
      #
      # @example Request:
      #   `curl -v -H "Content-Type: application/json" -X POST \
      #    --data-binary "{"card": {"original_text":"дом", \
      #    "translated_text":"house", "block_id":"1"}}" \
      #    -u login:password http://host/api/v1/cards.json`
      #
      # @example Response (200):
      #   {
      #     "card": {
      #       "id": 1,
      #       "original_text": "дом",
      #       "translated_text": "house",
      #       "review_date": null,
      #       "block_id": 1,
      #       "user_id": 1,
      #       "created_at": "2016-12-16T12:25:06.623Z",
      #       "updated_at": "2016-12-16T12:25:06.623Z"
      #     }
      #   }
      #
      # @example Response (422):
      #   {
      #    "errors": ["Original text input values must be different"]
      #   }
      #
      def create
        card = @user.cards.build card_params
        if card.save
          render json: { card: card }
        else
          render_error 422, card.errors
        end
      end

      # = PUT /api/v1/cards/:id/review.json
      # Review a card.
      #
      # @example Request:
      #   `curl -v -H "Content-Type: application/json" -X PUT \
      #    --data-binary "{"card": {"user_translation":"дом"}}" \
      #    -u login:password http://host/api/v1/cards/1/review.json`
      #
      # @example Response (200):
      #   {
      #     "card": {
      #       "id": 1,
      #       "original_text": "дом",
      #       "translated_text": "house",
      #       "review_date": "2016-12-16T13:16:12.353Z",
      #       "block_id": 1,
      #       "user_id": 1,
      #       "created_at": "2016-12-16T12:25:06.623Z",
      #       "updated_at": "2016-12-16T12:25:06.623Z"
      #     }
      #   }
      #
      # @example Response (422):
      #   {
      #    "errors": ["You entered an invalid translation. Please try again."]
      #   }
      #
      def review
        check_result = @card.check_translation(card_params[:user_translation])

        if check_result[:state]
          return render json: { card: @card } if check_result[:distance].zero?
          error = I18n.t('global.alerts.translation_from_misprint',
                         user_translation: card_params[:user_translation],
                         original_text: @card.original_text,
                         translated_text: @card.translated_text)
        else
          error = I18n.t('global.alerts.incorrect_translation')
        end
        render_error 422, error
      end

      private

      def card_params
        params
          .require(:card)
          .permit(:original_text, :translated_text, :image,
                  :remote_image_url, :block_id, :user_translation)
      end

      def find_card
        @card = Card.find params[:id]
      end

      def find_block
        @block = Block.find card_params[:block_id]
      end

      def check_access
        return if @card&.user_id == @user.id
        return if @block&.user_id == @user.id
        render_error 403, I18n.t('global.alerts.not_authorized')
      end
    end
  end
end
