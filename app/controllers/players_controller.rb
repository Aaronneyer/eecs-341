class PlayersController < ApplicationController

  # GET /players
  # GET /players.json
  def index
    @players = Player.paginate(page: params[:page]).order("name")
    @title = "All Players"
  end

  # GET /players/1
  # GET /players/1.json
  def show
    @player = Player.find(params[:id])
    @title = @player.name
  end

  def search
  end
  def results
    @players = Player.where("name LIKE ?", "%#{params[:q]}").paginate(page: params[:page]).order("name")
    @title = "Results"
    render :index
  end
end
