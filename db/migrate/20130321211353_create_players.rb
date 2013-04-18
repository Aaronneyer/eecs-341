class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :position
      t.string :name
      t.string :url, unique: true

      t.timestamps
    end
  end
end
