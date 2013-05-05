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
    @positions = Player.all_positions
    @stats = (PlayerStats.column_names - ["id", "created_at", "updated_at"]).map{|c| [c.titleize, c]}
  end

  def results
    players = Player.arel_table
    @players = Player.where(players[:name].matches("%#{params[:q]}%"))
    @players = @players.years_stats
    @players = @players.where(players[:position].matches("%#{params[:position]}%")) if params[:position].present?
    @players = @players.where("players_years.year = ?", params[:year]) if params[:year].present?
    @players = @players.where("player_stats.#{params[:filter_by]} >= ?", params[:stats]) if params[:filter_by].present? && params[:stats].present?
    @players = @players.uniq.paginate(page: params[:page]).order("name")
    @title = "Results"
    render :index
  end

end
