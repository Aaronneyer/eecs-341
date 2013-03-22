json.array!(@teams) do |team|
  json.extract! team, :name, :city, :shortname
  json.url team_url(team, format: :json)
end