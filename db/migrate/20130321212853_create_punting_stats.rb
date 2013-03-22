class CreatePuntingStats < ActiveRecord::Migration
  def change
    create_table :punting_stats do |t|
      t.integer :punts
      t.integer :yards

      t.timestamps
    end
  end
end
