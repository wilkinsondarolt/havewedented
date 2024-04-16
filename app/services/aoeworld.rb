class Aoeworld
  include Singleton

  AOE4WORLD_URL = 'https://aoe4world.com'
  AOE4WORLD_API_URL = "#{AOE4WORLD_URL}/api/v0/"

  def player(id)
    return {} unless id.positive?

    url = "players/#{id}"

    response = connection.get(url)

    return {} unless response.success?

    JSON.parse(response.body)
  end

  def players(name)
    return [] if name.blank?

    url = "players/search?query=#{name}"

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
