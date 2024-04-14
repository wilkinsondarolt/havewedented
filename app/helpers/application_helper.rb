module ApplicationHelper
  def game_url(player_id:, game_id:)
    "#{Aoeworld::AOE4WORLD_URL}/players/#{player_id}/games/#{game_id}"
  end

  def player_url(player_id)
    "#{Aoeworld::AOE4WORLD_URL}/players/#{player_id}"
  end
end
