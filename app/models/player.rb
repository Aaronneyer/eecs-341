class Player < ActiveRecord::Base
  belongs_to :current_team, class_name: "Team"
  has_many :players_teams
  has_many :players_games
  has_many :teams, through: :players_teams
  has_many :games, through: :players_games
  has_many :players_years

  scope :years_stats, -> {joins(:players_years => :stats)}
end
