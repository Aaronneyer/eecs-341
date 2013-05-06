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


end

