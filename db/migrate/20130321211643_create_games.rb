class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.date :date
      t.integer :year
      t.integer :week
      t.references :home_team
      t.references :away_team
      t.references :home_team_stats
      t.references :away_team_stats
      t.integer :result

      t.timestamps
    end
  end
end
