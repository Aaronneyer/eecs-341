class HomeController < ApplicationController
  def home
    @randplayer = Player.find(rand(Player.count))
    @randteam = "Test"
  end
end
