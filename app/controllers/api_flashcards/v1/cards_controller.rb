# frozen_string_literal: true
module ApiFlashcards
  module V1
    class CardsController < ApiFlashcards::MainController
      before_action :find_card, only: [:review]
      before_action :find_block, only: [:create]
      before_action :check_access, only: [:review, :create]

      def index
        @cards = @user.cards
        render json: { cards: @cards }
      end

      def create
        card = @user.cards.build card_params
        if card.save
          render json: { card: card }
        else
          render_error 422, card.errors
        end
      end

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
          .permit(:original_text, :translated_text, :review_date,
                  :image, :image_cache, :remove_image,
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
