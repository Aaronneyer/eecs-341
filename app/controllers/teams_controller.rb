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

  def search
  end

  def results
    teams = Team.arel_table
    @teams = Team.years_stats
    @teams = @teams.where(teams[:name].matches("%#{params[:search]}%")) if params[:search].present?
    @teams = @teams.where("team_years.year = ?", params[:year]) if params[:year].present?
    @teams = @teams.where("team_stats.wins >= ?", params[:stats]) if params[:stats].present?
    @teams = @teams.uniq
    @teams = @teams.paginate(page: params[:page]).order("name");
    @title = "Results"
    render :index
  end
=begin
    Players = Player.arel_table
    @players = Player.years_stats
    @players = @players.where(players[:name].matches("%#{params[:search]}%")) if params[:search].present?
    @players = @players.where(players[:position].matches("%#{params[:position]}%")) if params[:position].present?
    @players = @players.where("players_years.year = ?", params[:year]) if params[:year].present?
    @players = @players.where("player_stats.#{params[:filter_by]} >= ?", params[:stats]) if params[:filter_by].present? && params[:stats].present?
    @players = @players.uniq
    @players = @players.paginate(page: params[:page]).order("name")
    @title = "Results"
    render :index
  end
=end
end
