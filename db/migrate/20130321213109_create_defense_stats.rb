class CreateDefenseStats < ActiveRecord::Migration
  def change
    create_table :defense_stats do |t|
      t.integer :solo_tackles
      t.integer :assist_tackles
      t.float :sacks
      t.integer :passes_defended
      t.integer :interceptions
      t.integer :interception_touchdowns
      t.integer :fumbles_forced
      t.integer :fumbles_recovered
      t.integer :fumbles_touchdown

      t.timestamps
    end
  end
end
