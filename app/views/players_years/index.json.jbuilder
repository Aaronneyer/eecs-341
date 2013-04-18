json.array!(@players_years) do |players_year|
  json.extract! players_year, :player_id, :year, :passing_stats_id, :rushing_stats_id, :receiving_stats_id, :return_stats_id, :kicking_stats_id, :punting_stats_id, :defense_stats_id
  json.url players_year_url(players_year, format: :json)
end