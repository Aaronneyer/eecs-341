class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.datetime :date
      t.references :home_team
      t.references :away_team
      t.string :weather

      t.timestamps
    end
  end
end
