class HomeController < ApplicationController
  def home
    years = PlayersYear.where("year >= ?", 2000)
    @lastyear = years.first(:offset => rand(years.count))
    @randplayer = @lastyear.player
    @randteam = Team.active_teams.sample
    @recentgame = @randteam.away_games.where("year >= ?", 2000).sample
  end
end
