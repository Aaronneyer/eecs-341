class CreateReceivingStats < ActiveRecord::Migration
  def change
    create_table :receiving_stats do |t|
      t.integer :receptions
      t.integer :targets
      t.integer :yards
      t.integer :touchdowns
      t.integer :fumbles

      t.timestamps
    end
  end
end
