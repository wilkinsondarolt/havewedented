class Aoeworld
  include Singleton

  DEFAULT_SEARCH_LEADERBOARD = 'rm_solo'
  AOE4WORLD_API_URL = 'https://aoe4world.com/api/v0/'

  def players(name)
    return [] if name.blank?

    url = "players/autocomplete?leaderboard=#{DEFAULT_SEARCH_LEADERBOARD}&query=#{name}"

    response = connection.get(url)

    return [] unless response.success?

    JSON.parse(response.body)['players']
  end

  def games(player_id:, opponent_id:)
    url = "players/#{player_id}/games?opponent_profile_id=#{opponent_id}"

    response = connection.get(url)

    return [] unless response.success?

    JSON.parse(response.body)['games']
  end

  private

  def connection
    @connection ||= Faraday.new(url: AOE4WORLD_API_URL)
  end
end
