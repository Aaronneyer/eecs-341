class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.string :city
      t.boolean :active
      t.string :shortname
      t.index :shortname, unique: true

      t.timestamps
    end
  end
end
