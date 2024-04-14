class PlayersController < ApplicationController
  def index
    name = permitted_params[:name]

    render json: Aoeworld.instance.players(name)
  end

  private

  def permitted_params
    params.permit(:name)
  end
end
