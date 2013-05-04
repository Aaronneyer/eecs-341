class CreateTeamYears < ActiveRecord::Migration
  def change
    create_table :team_years do |t|
      t.references :team
      t.index :team_id
      t.references :stats
      t.integer :year
      t.integer :wins
      t.integer :losses
      t.integer :ties

      t.timestamps
    end
  end
end
