class CreateTeamYears < ActiveRecord::Migration
  def change
    create_table :team_years do |t|
      t.references :team, index: true
      t.references :team_stats
      t.integer :year

      t.timestamps
    end
  end
end
