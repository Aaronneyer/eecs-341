class CreatePlayersTeams < ActiveRecord::Migration
  def change
    create_table :players_teams do |t|
      t.references :player, index: true
      t.references :team, index: true
      t.integer :start
      t.integer :end

      t.timestamps
    end
  end
end
