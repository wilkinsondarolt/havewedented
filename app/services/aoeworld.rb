class Aoeworld
  include Singleton

  AOE4WORLD_URL = 'https://aoe4world.com'
  AOE4WORLD_API_URL = "#{AOE4WORLD_URL}/api/v0/"

  AOE4WORLD_SHORT_CACHE_TIME = 1.minute
  AOE4WORLD_LONG_CACHE_TIME = 1.minute

  def player(id)
    return {} unless id.positive?

    player_info = cached_response(
      url: "players/#{id}",
      cache_key: "player_#{id}_data",
      expires_in: AOE4WORLD_LONG_CACHE_TIME
    )

    return {} if player_info.empty?

    JSON.parse(player_info)
  end

  def players(name)
    return [] if name.blank?

    players_data = cached_response(
      url: "players/search?query=#{name}",
      cache_key: "players_#{name}_data",
      expires_in: AOE4WORLD_LONG_CACHE_TIME
    )

    return [] if players_data.empty?

    JSON.parse(players_data)['players']
  end

  def games(player_id:, opponent_id:)
    games_data = cached_response(
      url: "players/#{player_id}/games?opponent_profile_id=#{opponent_id}",
      cache_key: "player_#{player_id}_opponent_#{opponent_id}_games",
      expires_in: AOE4WORLD_SHORT_CACHE_TIME
    )

    return [] if games_data.empty?

    JSON.parse(games_data)['games']
  end

  private

  def connection
    @connection ||= Faraday.new(url: AOE4WORLD_API_URL)
  end

  def cached_response(url:, cache_key:, expires_in:)
    Rails.cache.fetch(cache_key, expires_in: expires_in) do
      response = connection.get(url)

      response.success? ? response.body : ""
    end
  end
end
