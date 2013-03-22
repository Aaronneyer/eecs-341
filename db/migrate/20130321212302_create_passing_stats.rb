class CreatePassingStats < ActiveRecord::Migration
  def change
    create_table :passing_stats do |t|
      t.integer :completions
      t.integer :attempts
      t.integer :yards
      t.integer :touchdowns
      t.integer :interceptions
      t.integer :sacked
      t.float :rating

      t.timestamps
    end
  end
end
