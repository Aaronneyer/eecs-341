class Game < ActiveRecord::Base
  belongs_to :home_team, class_name: "Team"
  belongs_to :away_team, class_name: "Team"
  belongs_to :home_team_stats, class_name: "TeamStats"
  belongs_to :away_team_stats, class_name: "TeamStats"
  has_many :players_games
  has_many :players, through: :players_games

  def winning_team
    case self.winner
    when 0
      return self.home_team
    when 1
      return self.away_team
    when 2
      return nil #It's a tie
    end
  end

end
