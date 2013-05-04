# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20130418163151) do

  create_table "games", force: true do |t|
    t.datetime "date"
    t.integer  "year"
    t.integer  "week"
    t.integer  "home_team_id"
    t.integer  "away_team_id"
    t.integer  "winning_team_id"
    t.string   "weather"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", force: true do |t|
    t.string   "position"
    t.string   "name"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "players", ["url"], name: "index_players_on_url", unique: true

  create_table "players_games", id: false, force: true do |t|
    t.integer  "player_id"
    t.integer  "game_id"
    t.integer  "stats_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "players_games", ["player_id", "game_id"], name: "index_players_games_on_player_id_and_game_id"

  create_table "players_teams", force: true do |t|
    t.integer  "player_id"
    t.integer  "team_id"
    t.integer  "start"
    t.integer  "end"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "players_teams", ["player_id", "team_id"], name: "index_players_teams_on_player_id_and_team_id"

  create_table "players_years", force: true do |t|
    t.integer  "player_id"
    t.integer  "year"
    t.integer  "stats_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "players_years", ["player_id"], name: "index_players_years_on_player_id"

  create_table "stats", force: true do |t|
    t.integer  "rushing_attempts"
    t.integer  "rushing_yards"
    t.integer  "rushing_touchdowns"
    t.integer  "fumbles"
    t.integer  "receptions"
    t.integer  "receiving_yards"
    t.integer  "receiving_touchdowns"
    t.integer  "completions"
    t.integer  "attempts"
    t.integer  "passing_yards"
    t.integer  "passing_touchdowns"
    t.integer  "interceptions_thrown"
    t.integer  "times_sacked"
    t.float    "qb_rating"
    t.integer  "solo_tackles"
    t.integer  "assist_tackles"
    t.float    "sacks"
    t.integer  "passes_defended"
    t.integer  "interceptions"
    t.integer  "interception_touchdowns"
    t.integer  "fumbles_forced"
    t.integer  "fumbles_recovered"
    t.integer  "fumbles_touchdowns"
    t.integer  "kick_return_attempts"
    t.integer  "kick_return_yards"
    t.integer  "kick_return_touchdowns"
    t.integer  "punt_return_attempts"
    t.integer  "punt_return_yards"
    t.integer  "punt_return_touchdowns"
    t.integer  "field_goals_made"
    t.integer  "field_goals_attempted"
    t.integer  "extra_points_made"
    t.integer  "extra_points_attempted"
    t.integer  "punts"
    t.integer  "punt_yards"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "team_years", force: true do |t|
    t.integer  "team_id"
    t.integer  "stats_id"
    t.integer  "year"
    t.integer  "wins"
    t.integer  "losses"
    t.integer  "ties"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "team_years", ["team_id"], name: "index_team_years_on_team_id"

  create_table "teams", force: true do |t|
    t.string   "name"
    t.string   "city"
    t.boolean  "active"
    t.string   "shortname"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teams", ["shortname"], name: "index_teams_on_shortname", unique: true

end
