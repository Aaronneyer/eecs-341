json.array!(@players) do |player|
  json.extract! player, :position, :name, :shortname, :integer
  json.url player_url(player, format: :json)
end