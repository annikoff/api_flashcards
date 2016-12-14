# frozen_string_literal: true
module ApiFlashcards
  module V1
    class CardsController < ApiFlashcards::MainController
      before_action :find_card, only: [:review]
      before_action :find_block, only: [:create]
      def index
        @cards = @user.cards
        render json: { cards: @cards }
      end

      def create
        @card = @user.cards.create!(card_params)
        render json: { card: @card }
      end

      def review; end

      private

      def card_params
        params.require(:card).permit!
      end

      def find_card
        @card = Card.find card_params[:id]
      end

      def find_block
        Block.find card_params[:block_id]
      end
    end
  end
end
