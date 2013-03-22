json.array!(@plays) do |play|
  json.extract! play, :game_id, :player_id, :type, :yards
  json.url play_url(play, format: :json)
end