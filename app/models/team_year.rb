class TeamYear < ActiveRecord::Base
  belongs_to :team
  belongs_to :team_stats
end
