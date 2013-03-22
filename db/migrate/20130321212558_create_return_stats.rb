class CreateReturnStats < ActiveRecord::Migration
  def change
    create_table :return_stats do |t|
      t.integer :kick_return_attempts
      t.integer :kick_return_yards
      t.integer :kick_return_touchdowns
      t.integer :punt_return_attempts
      t.integer :punt_return_yards
      t.integer :punt_return_touchdowns

      t.timestamps
    end
  end
end
