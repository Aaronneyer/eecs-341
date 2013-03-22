class CreatePlayersTeams < ActiveRecord::Migration
  def change
    create_table :players_teams, id: false do |t|
      t.references :player
      t.references :team
      t.index [:player_id, :team_id]
      t.date :start
      t.date :end

      t.timestamps
    end
  end
end
