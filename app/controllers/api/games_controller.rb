class Api::GamesController < ApplicationController


  # GET /cards
  # GET /cards.json
  def show
    render json: game
  end

  private

  def game
    @game ||= Game.find_by_id(params[:id]) || Game.first
  end

end
