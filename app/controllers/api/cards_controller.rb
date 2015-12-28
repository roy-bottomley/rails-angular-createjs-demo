class Api::CardsController < ApplicationController

  # GET /cards
  # GET /cards.json
  def index
    if game
      render json: @game.cards.all
    else
      render json: Card.all
    end
  end

  def show
    if card
      render json: card
    else
      render json: {}
    end
  end

  private

  def game
    @game ||= Game.find_by_id(params[:game_id])  if params[:game_id]
  end

  def card
    @card ||= Card.find_by_id(params[:id])  if params[:id]
  end

end
