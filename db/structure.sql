CREATE TABLE "games" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "date" date, "year" integer, "week" integer, "home_team_id" integer, "away_team_id" integer, "home_team_stats_id" integer, "away_team_stats_id" integer, "result" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "player_stats" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "rushing_attempts" integer, "rushing_yards" integer, "rushing_touchdowns" integer, "fumbles" integer, "receptions" integer, "receiving_yards" integer, "receiving_touchdowns" integer, "completions" integer, "attempts" integer, "passing_yards" integer, "passing_touchdowns" integer, "interceptions_thrown" integer, "times_sacked" integer, "qb_rating" float, "solo_tackles" integer, "assist_tackles" integer, "sacks" float, "passes_defended" integer, "interceptions" integer, "interception_touchdowns" integer, "fumbles_forced" integer, "fumbles_recovered" integer, "fumbles_touchdowns" integer, "kick_return_attempts" integer, "kick_return_yards" integer, "kick_return_touchdowns" integer, "punt_return_attempts" integer, "punt_return_yards" integer, "punt_return_touchdowns" integer, "field_goals_made" integer, "field_goals_attempted" integer, "extra_points_made" integer, "extra_points_attempted" integer, "punts" integer, "punt_yards" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "players" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "position" varchar(255), "name" varchar(255), "url" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "players_games" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "player_id" integer, "game_id" integer, "team_id" integer, "player_stats_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "players_teams" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "player_id" integer, "team_id" integer, "start" integer, "end" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "players_years" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "player_id" integer, "year" integer, "player_stats_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "team_stats" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "wins" integer, "losses" integer, "ties" integer, "points_scored" integer, "points_allowed" integer, "first_downs_made" integer, "offensive_total_yards" integer, "offensive_passing_yards" integer, "offensive_rushing_yards" integer, "turnovers_lost" integer, "first_downs_allowed" integer, "total_yards_allowed" integer, "passing_yards_allowed" integer, "rushing_yards_allowed" integer, "turnovers_gained" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "team_years" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "team_id" integer, "team_stats_id" integer, "year" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "teams" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "city" varchar(255), "active" boolean, "shortname" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE INDEX "index_players_games_on_game_id" ON "players_games" ("game_id");
CREATE INDEX "index_players_games_on_player_id" ON "players_games" ("player_id");
CREATE INDEX "index_players_games_on_team_id" ON "players_games" ("team_id");
CREATE UNIQUE INDEX "index_players_on_url" ON "players" ("url");
CREATE INDEX "index_players_teams_on_player_id" ON "players_teams" ("player_id");
CREATE INDEX "index_players_teams_on_team_id" ON "players_teams" ("team_id");
CREATE INDEX "index_players_years_on_player_id" ON "players_years" ("player_id");
CREATE INDEX "index_team_years_on_team_id" ON "team_years" ("team_id");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20130321211353');

INSERT INTO schema_migrations (version) VALUES ('20130321211527');

INSERT INTO schema_migrations (version) VALUES ('20130321211643');

INSERT INTO schema_migrations (version) VALUES ('20130321211845');

INSERT INTO schema_migrations (version) VALUES ('20130321212129');

INSERT INTO schema_migrations (version) VALUES ('20130321213156');

INSERT INTO schema_migrations (version) VALUES ('20130410161017');

INSERT INTO schema_migrations (version) VALUES ('20130418163151');

INSERT INTO schema_migrations (version) VALUES ('20130504162107');
