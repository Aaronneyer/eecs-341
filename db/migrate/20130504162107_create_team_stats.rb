class CreateTeamStats < ActiveRecord::Migration
  def change
    create_table :team_stats do |t|
      t.integer :wins
      t.integer :losses
      t.integer :ties
      t.integer :points_scored
      t.integer :points_allowed
      t.integer :first_downs_made
      t.integer :offensive_total_yards
      t.integer :offensive_passing_yards
      t.integer :offensive_rushing_yards
      t.integer :turnovers_lost
      t.integer :first_downs_allowed
      t.integer :total_yards_allowed
      t.integer :passing_yards_allowed
      t.integer :rushing_yards_allowed
      t.integer :turnovers_gained

      t.timestamps
    end
  end
end
