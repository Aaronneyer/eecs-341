class HomeController < ApplicationController
  def home
    years = PlayersYear.where("year >= ?", 2012)
    @lastyear = years.first(:offset => rand(years.count))
    @randplayer = @lastyear.player
    @randteam = Team.active_teams.sample
    @recentgame = @randteam.away_games.order("date DESC").first
  end
end
