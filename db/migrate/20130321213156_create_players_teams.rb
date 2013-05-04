class CreatePlayersTeams < ActiveRecord::Migration
  def change
    create_table :players_teams do |t|
      t.references :player
      t.references :team
      t.index [:player_id, :team_id], unique: false
      t.integer :start
      t.integer :end

      t.timestamps
    end
  end
end
