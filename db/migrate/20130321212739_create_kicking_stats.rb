class CreateKickingStats < ActiveRecord::Migration
  def change
    create_table :kicking_stats do |t|
      t.integer :field_goals_made
      t.integer :field_goals_attempted
      t.integer :extra_points_made
      t.integer :extra_points_attempted

      t.timestamps
    end
  end
end
