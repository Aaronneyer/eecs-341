class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.integer :rushing_attempts
      t.integer :rushing_yards
      t.integer :rushing_touchdowns
      t.integer :fumbles
      t.integer :receptions
      t.integer :receiving_yards
      t.integer :receiving_touchdowns
      t.integer :completions
      t.integer :attempts
      t.integer :passing_yards
      t.integer :passing_touchdowns
      t.integer :interceptions_thrown
      t.integer :times_sacked
      t.float :qb_rating
      t.integer :solo_tackles
      t.integer :assist_tackles
      t.float :sacks
      t.integer :passes_defended
      t.integer :interceptions
      t.integer :interception_touchdowns
      t.integer :fumbles_forced
      t.integer :fumbles_recovered
      t.integer :fumbles_touchdowns
      t.integer :kick_return_attempts
      t.integer :kick_return_yards
      t.integer :kick_return_touchdowns
      t.integer :punt_return_attempts
      t.integer :punt_return_yards
      t.integer :punt_return_touchdowns
      t.integer :field_goals_made
      t.integer :field_goals_attempted
      t.integer :extra_points_made
      t.integer :extra_points_attempted
      t.integer :punts
      t.integer :punt_yards

      t.timestamps
    end
  end
end
