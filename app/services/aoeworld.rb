class Aoeworld
  include Singleton

  AOE4WORLD_URL = 'https://aoe4world.com'
  AOE4WORLD_API_URL = "#{AOE4WORLD_URL}/api/v0/"

  def player(id)
    return {} unless id.positive?

    player_info = Rails.cache.fetch("player_#{id}_data", expires_in: 1.day) do
      url = "players/#{id}"
      response = connection.get(url)

      response.success? ? response.body : ""
    end

    return {} if player_info.empty?

    JSON.parse(player_info)
  end

  def players(name)
    return [] if name.blank?

    players_data = Rails.cache.fetch("players_#{name}_data", expires_in: 1.minute) do
      url = "players/search?query=#{name}"
      response = connection.get(url)

      response.success? ? response.body : ""
    end

    return [] if players_data.empty?

    JSON.parse(players_data)['players']
  end

  def games(player_id:, opponent_id:)
    games_data = Rails.cache.fetch("player_#{player_id}_opponent_#{opponent_id}_games", expires_in: 1.minute) do
      url = "players/#{player_id}/games?opponent_profile_id=#{opponent_id}"
      response = connection.get(url)

      response.success? ? response.body : ""
    end

    return [] if games_data.empty?

    JSON.parse(games_data)['games']
  end

  private

  def connection
    @connection ||= Faraday.new(url: AOE4WORLD_API_URL)
  end
end
