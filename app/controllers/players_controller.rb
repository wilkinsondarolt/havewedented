class PlayersController < ApplicationController
  def index
    name = permitted_params[:name]

    render json:search_players(name)
  end

  private

  def permitted_params
    params.permit(:name)
  end

  def search_players(name)
    aoeworld_users = Aoeworld.instance.players(name)

    aoeworld_users.map do |user|
      {
        id: user["profile_id"],
        name: user['name']
      }
    end
  end
end
