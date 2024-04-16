class SearchController < ApplicationController
  def index
    search_params = search_permitted_params[:search] || {}

    @player = search_player(search_params[:player])
    @opponent = search_player(search_params[:opponent])
    @games = search_games(search_params[:player], search_params[:opponent])
  end

  private

  def search_games(player, opponent)
    return [] if player.blank? || opponent.blank?

    Aoeworld.instance.games(
      player_id: player,
      opponent_id: opponent
    )
  end

  def search_player(id)
    Aoeworld.instance.player(id.to_i)
  end

  def search_permitted_params
    params.permit(search: [:player, :opponent])
  end
end
