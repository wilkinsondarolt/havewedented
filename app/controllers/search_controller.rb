class SearchController < ApplicationController
  def index
    @games = search_games
  end

  private

  def search_games
    search_params = {player: nil, opponent: nil}.merge(search_permitted_params[:search].to_h)
    search_params.to_h => {player:, opponent:}

    return [] if player.blank? || opponent.blank?

    Aoeworld.instance.games(
      player_id: player,
      opponent_id: opponent
    )
  end

  def search_permitted_params
    params.permit(search: [:player, :opponent])
  end
end
