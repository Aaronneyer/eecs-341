class PlayersController < ApplicationController
  require 'will_paginate/array'
  autocomplete :player, :name, display_value: :autocomplete_display, full: true

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
    @teams = Team.all
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
    @players = Player.find_by_sql(["SELECT p.* FROM players p, players_teams pt, teams t WHERE p.id = pt.player_id AND pt.start <= ?
                                  AND pt.end >= ? AND pt.team_id = t.id AND t.id = ?
                                  AND NOT EXISTS (SELECT * FROM games g WHERE (g.away_team_id = t.id OR g.home_team_id = t.id)
                                  AND g.year = ? AND NOT EXISTS (SELECT * FROM players_games pg WHERE pg.game_id = g.id
                                  AND pg.team_id = t.id AND pg.player_id = p.id))",
                                  params[:year], params[:year], params[:team], params[:year]]).paginate(page: params[:page])
    @title = "Query 1 Result"
    render :index
  end

  def averageyards
    pid = ActiveRecord::Base.sanitize(params[:player])
    startyear = ActiveRecord::Base.sanitize(params[:start])
    endyear = ActiveRecord::Base.sanitize(params[:end])
    filterfield = ActiveRecord::Base.sanitize(params[:filter_by])
    result = ActiveRecord::Base.connection.execute("SELECT AVG(ps.#{filterfield}) FROM games g, players p, players_games pg, player_stats ps
             WHERE p.id = #{pid} AND p.id = pg.player_id AND pg.game_id = g.id
             AND g.year >= #{startyear} AND g.year <= #{endyear} AND pg.player_stats_id = ps.id")
    @result = "Average #{filterfield} per game between #{startyear} and #{endyear} for #{Player.find(params[:player]).name}: #{Float(result[0][0]).round(2)}"
    @title = "Query 2 Result"
    render :base_result
  end

  def yardsagainstteam
    pid = ActiveRecord::Base.sanitize(params[:player1])
    tid = ActiveRecord::Base.sanitize(params[:team])
    startyear = ActiveRecord::Base.sanitize(params[:start])
    endyear = ActiveRecord::Base.sanitize(params[:end])
    filterfield = ActiveRecord::Base.sanitize(params[:filter_by])
    result = ActiveRecord::Base.connection.execute("SELECT SUM(ps.#{filterfield}) FROM games g, players p, teams t, players_games pg, player_stats ps
             WHERE p.id = #{pid} AND p.id = pg.player_id AND pg.game_id = g.id
             AND ((g.home_team_id=#{tid} AND g.away_team_id = pg.team_id)
             OR (g.away_team_id=#{tid} AND g.home_team_id = pg.team_id))
             AND g.year >= #{startyear} AND g.year <= #{endyear} AND pg.player_stats_id = ps.id")
    @result = "Total #{filterfield} between #{startyear} and #{endyear} against #{Team.find(params[:team]).name} for #{Player.find(params[:player1]).name}: #{Float(result[0][0]).round(2)}"
    @title = "Query 3 Result"
    render :base_result
  end

  def recordagainstteam
    pid = ActiveRecord::Base.sanitize(params[:player2])
    tid = ActiveRecord::Base.sanitize(params[:team])
    startyear = ActiveRecord::Base.sanitize(params[:start])
    endyear = ActiveRecord::Base.sanitize(params[:end])
    result = ActiveRecord::Base.connection.execute("SELECT SUM(ts.wins), SUM(ts.losses), SUM(ts.ties) FROM games g, players p, players_games pg, team_stats ts
             WHERE p.id = #{pid} AND p.id = pg.player_id AND pg.game_id = g.id
             AND ((g.home_team_id=#{tid} AND g.away_team_id = pg.team_id AND g.away_team_stats_id=ts.id)
             OR (g.away_team_id=#{tid} AND g.home_team_id = pg.team_id AND g.home_team_stats_id=ts.id))
             AND g.year >= #{startyear} AND g.year <= #{endyear}")[0]
    @result = "Total record between #{startyear} and #{endyear} against #{Team.find(params[:team]).name} for #{Player.find(params[:player2]).name}: #{result[0]}-#{result[1]}-#{result[2]}"
    @title = "Query 3 Result"
    render :base_result
  end

end
