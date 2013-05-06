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
    @allteams = Team.all_teams 
    @stats = (PlayerStats.column_names - ["id", "created_at", "updated_at"]).map{|c| [c.titleize, c]}
  end

  def results
    players = Player.arel_table
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

  def games
    @year = params[:year]
    @player = Player.find(params[:id])
    @games = @player.players_games.joins(:game).where("games.year = ?", @year)
    render partial: "games"
  end

  # Given a team and a year, find all players that have played in all games for their team in that year.
  def playallgames
    funkyids = Player.find_by_sql("SELECT p.id  FROM players p, players_teams pt, teams t WHERE p.id = pt.player_id AND pt.start <= #{params[:year]}  AND pt.end >=  #{params[:year]} AND pt.team_id = t.id AND t.name='#{params[:team_name]}'  AND NOT EXISTS (SELECT * FROM games g WHERE (g.away_team_id = t.id OR g.home_team_id = t.id) AND g.year=#{params[:year]} AND NOT EXISTS (SELECT * FROM players_games pg WHERE pg.game_id = g.id AND pg.team_id = t.id AND pg.player_id = p.id))") if params[:year].present? && params[:team_name].present?

    pids = funkyids.map {|p| p.id}
    @players = Player.find(pids); 
    @players = @players.paginate(page: params[:page])
    @title = "Results for query 1"
    render :index

  end

end
