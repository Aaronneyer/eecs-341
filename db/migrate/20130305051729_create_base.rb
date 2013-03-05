class CreateBase < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :position #Should position be it's own class?
      t.string :name
      t.string :shortname
      t.integer :team_id
      t.timestamps
    end

    create_table :teams do |t|
      t.string :name
      t.string :city
      t.string :shortname
    end

    create_table :games do |t|
      t.datetime :date
      t.integer :home_team_id
      t.integer :away_team_id
      t.string :weather
      t.string :gameid
    end

    create_table :play do |t|
      t.integer :game_id
      t.integer :player_id
      t.string :type
      t.integer :yards
    end

    create_table :teams_years, id: false do |t|
      t.integer :team_id
      t.integer :year
      t.integer :wins
      t.integer :losses
      t.integer :ties
    end

    create_table :players_games, id: false do |t|
      t.integer :player_id
      t.integer :game_id
      t.integer :passing_stats_id
      t.integer :rushing_stats_id
      t.integer :receiving_stats_id
      t.integer :return_stats_id
      t.integer :kicking_stats_id
      t.integer :punting_stats_id
      t.integer :defense_stats_id
    end

    create_table :passing_stats do |t|
      t.integer :completions
      t.integer :attempts
      t.integer :yards
      t.integer :touchdowns
      t.integer :interceptions
      t.integer :sacked
      t.float :rating
    end

    create_table :rushing_stats do |t|
      t.integer :attempts
      t.integer :yards
      t.integer :touchdowns
      t.integer :fumbles
    end

    create_table :receiving_stats do |t|
      t.integer :receptions
      t.integer :targets
      t.integer :yards
      t.integer :touchdowns
      t.integer :fumbles
    end

    create_table :return_stats do |t|
      t.integer :kick_return_attempts
      t.integer :kick_return_yards
      t.integer :kick_return_touchdowns
      t.integer :punt_return_attempts
      t.integer :punt_return_yards
      t.integer :punt_return_touchdowns
    end

    create_table :kicking_stats do |t|
      t.integer :field_goals_made
      t.integer :field_goals_attempted
      t.integer :extra_points_made
      t.integer :extra_points_attempted
    end
    
    create_table :punting_stats do |t|
      t.integer :punts
      t.integer :yards
    end

    create_table :defense_stats do |t|
      t.integer :solo_tackles
      t.integer :assist_tackles
      t.float :sacks
      t.integer :passes_defended
      t.integer :interceptions
      t.integer :interception_touchdowns
      t.integer :fumbles_forced
      t.integer :fumbles_recovered
      t.integer :fumbles_touchdowns
    end

    create_table :players_teams, id: false do |t|
      t.integer :player_id
      t.integer :team_id
      t.date :start
      t.date :end
    end
  end
end
