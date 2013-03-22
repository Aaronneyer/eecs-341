json.array!(@games) do |game|
  json.extract! game, :date, :home_team_id, :away_team_id, :weather, :game_id
  json.url game_url(game, format: :json)
end