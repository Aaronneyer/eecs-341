class Player < ActiveRecord::Base
  belongs_to :current_team, class_name: "Team"
  has_many :players_teams
  has_many :players_games
  has_and_belongs_to_many :teams
  has_and_belongs_to_many :games
  has_many :plays
  has_many :players_years

  scope :years_stats, -> {joins(:players_years => :stats)}
end
