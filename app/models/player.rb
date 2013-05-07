class Player < ActiveRecord::Base
  has_many :players_teams
  has_many :players_games
  has_many :teams, through: :players_teams
  has_many :games, through: :players_games
  has_many :players_years
  scope :years_stats, -> {joins(:players_years => :player_stats)}

  def current_team
    self.players_teams.order("end DESC, start DESC").first.team
  end

  def current_team_name
    begin
      "#{current_team.city} #{current_team.name}"
    rescue
      ""
    end
  end

  def autocomplete_display
    "#{name} (#{current_team_name}, #{years_active.last})"
  end

  def years_active
    py = self.players_years.order("year")
    begin
      (py.first.year..py.last.year)
    rescue
      ""
    end
  end

  def positions
    position.split(",")
  end

  def self.all_positions
    self.all.collect(&:positions).flatten.uniq
  end
end
