class HomeController < ApplicationController
  def home
    years = PlayersYear.where("year >= ?", 2012)
    @lastyear = years.first(:offset => rand(years.count))
    @randplayer = @lastyear.player
    #recent_players = Player.where("(SELECT COUNT(*) FROM players_years WHERE player_id = players.id AND year > ?) > ?", 2010, 1)
    #@randplayer = recent_players.first(:offset => rand(recent_players.count))
    #@lastyear = @randplayer.players_years.last
    @randteam = "Test"
  end
end
