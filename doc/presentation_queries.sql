--Generic Search Query

SELECT DISTINCT "players".* FROM "players"
INNER JOIN "players_years" ON "players_years"."player_id" = "players"."id"
INNER JOIN "player_stats" ON "player_stats"."id" = "players_years"."player_stats_id"
WHERE ("players"."name" LIKE '%Johnson%') AND ("players"."position" LIKE '%RB%')
AND (players_years.year = '2011') AND (player_stats.rushing_yards >= '500')
ORDER BY name LIMIT 30 OFFSET 0

--Play all games for a given team in a given year

SELECT p.* FROM players p, players_teams pt, teams t WHERE p.id = pt.player_id AND pt.start <= '2011'
AND pt.end >= '2011' AND pt.team_id = t.id AND t.id = '7'
AND NOT EXISTS (SELECT * FROM games g WHERE (g.away_team_id = t.id OR g.home_team_id = t.id)
AND g.year = '2011' AND NOT EXISTS (SELECT * FROM players_games pg WHERE pg.game_id = g.id
AND pg.team_id = t.id AND pg.player_id = p.id))

--Average stat for a player over a given time period

SELECT AVG(ps.'rushing_yards') FROM games g, players p, players_games pg, player_stats ps
WHERE p.id = '6424' AND p.id = pg.player_id AND pg.game_id = g.id
AND g.year >= '2010' AND g.year <= '2012' AND pg.player_stats_id = ps.id

--Record for a player against a team over a given time period

SELECT SUM(ts.wins), SUM(ts.losses), SUM(ts.ties) FROM games g, players p, players_games pg, team_stats ts
WHERE p.id = '20160' AND p.id = pg.player_id AND pg.game_id = g.id
AND ((g.home_team_id='7' AND g.away_team_id = pg.team_id AND g.away_team_stats_id=ts.id)
OR (g.away_team_id='7' AND g.home_team_id = pg.team_id AND g.home_team_stats_id=ts.id))
AND g.year >= '2000' AND g.year <= '2012'

--Teams matching a search with atleast N wins in the given season

SELECT DISTINCT "teams".* FROM "teams"
INNER JOIN "team_years" ON "team_years"."team_id" = "teams"."id"
INNER JOIN "team_stats" ON "team_stats"."id" = "team_years"."team_stats_id"
WHERE (team_years.year = '2012') AND (team_stats.wins >= '5') ORDER BY name LIMIT 30 OFFSET 0

--Order teams by given stat in a given year

SELECT DISTINCT COUNT(DISTINCT "teams"."id") FROM "teams"
INNER JOIN "team_years" ON "team_years"."team_id" = "teams"."id"
INNER JOIN "team_stats" ON "team_stats"."id" = "team_years"."team_stats_id"
WHERE (team_years.year = '2011')

--Find teams that average N or more of a given stat for a given position in a given year

select t.* from players p, players_games pg, games g,
teams t, player_stats ps where g.year = '2012' and (g.away_team_id = t.id
or g.home_team_id = t.id) and pg.game_id = g.id and pg.team_id = t.id
and p.position = 'QB' and p.id = pg.player_id and
pg.player_stats_id = ps.id group by t.id
having avg(ps.'passing_yards') > 100

--Find teams that have atleast one player with a given minimum stat for the year

select t.* from players_years py, player_stats ps, players_teams pt, teams t
WHERE t.id = pt.team_id AND pt.player_id = py.player_id AND py.player_stats_id = ps.id
AND pt.start <= '2009' AND pt.end >= '2009' AND ps.'passing_yards' >= '500'

