class CreatePlayersGames < ActiveRecord::Migration
  def change
    create_table :players_games do |t|
      t.references :player, index: true
      t.references :game, index: true
      t.references :team, index: true
      t.references :player_stats

      t.timestamps
    end
  end
end
