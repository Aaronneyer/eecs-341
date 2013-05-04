class CreatePlayersGames < ActiveRecord::Migration
  def change
    create_table :players_games, id: false do |t|
      t.references :player
      t.references :game
      t.index [:player_id, :game_id]
      t.references :stats

      t.timestamps
    end
  end
end
