class TeamsController < ApplicationController

  def show
    @team = Team.find(params[:id])
  end

  # GET /teams
  # GET /teams.json
  def index
    @teams = Team.all
  end

  def games
    @year = params[:year]
    @team = Team.find(params[:id])
    @games = @team.games.where("games.year = ?", @year).order("date")
    render partial: "games"
  end
end
