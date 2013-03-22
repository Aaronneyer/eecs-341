class CreatePlays < ActiveRecord::Migration
  def change
    create_table :plays do |t|
      t.references :game
      t.references :player
      t.string :type
      t.integer :yards

      t.timestamps
    end
  end
end
