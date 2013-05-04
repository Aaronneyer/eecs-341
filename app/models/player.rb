class Player < ActiveRecord::Base
  has_many :players_teams
  has_many :players_games
  has_many :teams, through: :players_teams
  has_many :games, through: :players_games
  has_many :players_years

  scope :years_stats, -> {joins(:players_years => :stats)}

  def current_team
    self.players_teams.order("end DESC, start DESC").first
  end
end
