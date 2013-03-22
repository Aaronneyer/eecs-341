class CreatePlayersGames < ActiveRecord::Migration
  def change
    create_table :players_games, id: false do |t|
      t.references :player
      t.references :game
      t.index [:player_id, :game_id]
      t.references :passing_stats
      t.references :rushing_stats
      t.references :receiving_stats
      t.references :return_stats
      t.references :kicking_stats
      t.references :punting_stats
      t.references :defense_stats

      t.timestamps
    end
  end
end
