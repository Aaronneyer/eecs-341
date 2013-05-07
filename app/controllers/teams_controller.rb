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
    @positions = Player.all_positions
    #@teams = Team.all
    @stats = (PlayerStats.column_names - ["id", "created_at", "updated_at"]).map{|c| [c.titleize, c]}
    @team_stat_names = (TeamStats.column_names - ["id", "created_at", "updated_at"]).map{|c| [c.titleize, c]}
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

  def mostyardage
    teams = Team.arel_table
    @teams = Team.years_stats
    @teams = @teams.where("team_years.year = ?", params[:year]) if params[:year].present?
    @teams = @teams.uniq
    @teams = @teams.paginate(page: params[:page]).order(params[:stat_name])
    @teams = @teams.reverse
    @title = "Query 1 results"
    render :index
  end

  def teamavgforpos
    @teams = Team.find_by_sql(["select t.name, t.id from players p, players_games pg, games g, 
                              teams t, player_stats ps where g.year = ? and (g.away_team_id = t.id
                               or g.home_team_id = t.id) and pg.game_id = g.id and pg.team_id = t.id
                               and p.position = ? and p.id = pg.player_id and 
                               pg.player_stats_id = ps.id group by t.id
                               having avg(?) > ?", params[:year], params[:position], params[:stats], params[:yards]])
    puts @teams.count
    
    @teams = @teams.paginate(page: params[:page])
    
    @title = "Results"
    render :index
  end

  def teamhaspmin
    #@players = Players.where("players_teams.
  end
end


