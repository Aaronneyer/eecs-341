class CreateRushingStats < ActiveRecord::Migration
  def change
    create_table :rushing_stats do |t|
      t.integer :attempts
      t.integer :yards
      t.integer :touchdowns
      t.integer :fumbles

      t.timestamps
    end
  end
end
