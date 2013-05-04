class CreatePlayersYears < ActiveRecord::Migration
  def change
    create_table :players_years do |t|
      t.references :player, index: true
      t.integer :year
      t.references :player_stats

      t.timestamps
    end
  end
end
