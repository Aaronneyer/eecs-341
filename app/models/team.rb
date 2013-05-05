class Team < ActiveRecord::Base
  has_many :home_games, class_name: "Game", foreign_key: :home_team_id
  has_many :away_games, class_name: "Game", foreign_key: :away_team_id
  has_many :team_years
  has_many :players_teams
  has_many :players, through: :players_teams
  scope :years_stats, -> {joins(:team_years => :team_stats)}
  
  def self.active_teams
    self.where(active: true)
  end

  def players_in(year)
    players_teams.where("start <= ? AND end >= ?", year, year).collect{|pt| pt.player}.uniq
  end

  def games
    Game.where("home_team_id = ? OR away_team_id = ?", id, id)
  end
end
