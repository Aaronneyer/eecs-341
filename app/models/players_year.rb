class PlayersYear < ActiveRecord::Base
  belongs_to :player
  belongs_to :stats
end
