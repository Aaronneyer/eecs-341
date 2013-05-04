class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.datetime :date
      t.integer :year
      t.integer :week
      t.references :home_team
      t.references :away_team
      t.references :winning_team
      t.string :weather

      t.timestamps
    end
  end
end
