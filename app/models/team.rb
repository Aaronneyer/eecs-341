class Team < ActiveRecord::Base
  has_many :current_players, class_name: "Player"
  has_many :home_games, class_name: "Game", foreign_key: :home_team_id
  has_many :away_games, class_name: "Game", foreign_key: :away_team_id
  has_many :team_years
  has_many :players_teams
  has_and_belongs_to_many :players
end
