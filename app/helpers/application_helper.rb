module ApplicationHelper
  def player_data_to_collection(player_data)
    [
      [
        player_data['name'], player_data['profile_id']
      ]
    ]
  end

  def game_url(player:, game_id:)
    "#{Aoeworld::AOE4WORLD_URL}/players/#{player['profile_id']}/games/#{game_id}"
  end

  def player_url(player_id)
    "#{Aoeworld::AOE4WORLD_URL}/players/#{player_id}"
  end
end
