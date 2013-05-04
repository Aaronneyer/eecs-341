task :loaddata => ["db:drop", "db:migrate", :loadteams, :teamstats, :loadyears, :loadgames]

task :loadteams => :environment do
  require 'nokogiri'
  require 'open-uri'
  team_page = Nokogiri::HTML(open("http://www.pro-football-reference.com/teams/"))
  table = team_page.css("#teams_active")
  table.children.css("tbody").children.css("tr").each do |tr|
    a = tr.children.css("td").children.css("a").first
    city, name = a.content.match(/(.+) (\w+)/)[1..2]
    shortname = a.attribute("href").value.match(/teams\/(.*)\//)[1]
    Team.create(city: city, name: name, shortname: shortname, active: true)
    puts "Created #{city} #{name}"
  end
  table2 = team_page.css("#teams_inactive")
  table2.children.css("tbody").children.css("tr").each do |tr|
    a = tr.children.css("td").children.css("a").first
    city, name = a.content.match(/(.+) (\w+)/)[1..2]
    shortname = a.attribute("href").value.match(/teams\/(.*)\//)[1]
    Team.create(city: city, name: name, shortname: shortname, active: false)
    puts "Created #{city} #{name}"
  end
end

task :teamstats => :environment do
  require 'nokogiri'
  require 'open-uri'
  Team.all.each do |team|
    base_url = "http://www.pro-football-reference.com/teams/"
    team_doc = Nokogiri::HTML(open("#{base_url}#{team.shortname}"))
    table = team_doc.css("#team_index")
    puts "Starting on #{team.city} #{team.name}"
    rows = table.children.css("tbody").first.children.css("tr")
    rows.each do |tr|
      td = tr.children.css("td").first
      year = td.content.to_i
      break if year<2000
      year_doc = Nokogiri::HTML(open("#{base_url}#{team.shortname}/#{td.content}.htm"))
      scrape_team_year(year_doc, team, year)
    end
  end
end

def scrape_team_year(doc, team, year)
  puts "Starting on #{team.city} #{team.name} #{year}"
  wins, losses, ties = doc.content.match(/Record: (\d+-\d+-\d+)/)[1].split("-")
  game_table = doc.css("#team_gamelogs")
  year_table = doc.css("#team_stats")
  year_stats = get_table_hash(year_table)
  o = year_stats[0]
  d = year_stats[1]
  ystats = TeamStats.new(wins: wins, losses: losses, ties: ties,
                      points_scored: o["Pts"],
                      points_allowed: d["Pts"],
                      first_downs_made: o["1stD"],
                      offensive_total_yards: o["Yds"],
                      offensive_passing_yards: o["Passing_Yds"],
                      offensive_rushing_yards: o["Rushing_Yds"],
                      turnovers_lost: o["TO"],
                      first_downs_allowed: d["1stD"],
                      total_yards_allowed: d["Yds"],
                      passing_yards_allowed: d["Passing_Yds"],
                      rushing_yards_allowed: d["Rushing_Yds"],
                      turnovers_gained: d["TO"])
  t = TeamYear.new(team: team, year: year, team_stats_id: ystats.id)

  game_stats = get_table_hash(game_table)
  game_stats.each do |g|
    if g["Date"].present?
      break if g["Date"]=="Playoffs"
      is_away = g[""]=="@"
      if is_away
        home = Team.find_by_shortname(g["Opp"])
        away = team
      else
        away = Team.find_by_shortname(g["Opp"])
        home = team
      end
      break if away.nil? || home.nil?
      tm_score = g["Score_Tm"].to_i
      opp_score = g["Score_Opp"].to_i
      gwins = 0
      glosses = 0
      gties = 0
      date = Date.parse(g["Date"])
      game = Game.find_or_create_by(year: year, week: g["Week"], away_team_id: away.id, home_team_id: home.id)
      game.date = Date.parse("#{g["Date"]} #{date.month==1 ? year+1 : year}")
      if tm_score > opp_score
        gwins = 1
        if is_away
          game.result = 1
        else
          game.result = 0
        end
      elsif tm_score < opp_score
        glosses = 1
        if is_away
          game.result = 0
        else
          game.result = 1
        end
      else
        gties = 1
        game.result = 2
      end
      stats = TeamStats.new(wins: gwins, losses: glosses, ties: gties,
                         points_scored: g["Score_Tm"],
                         points_allowed: g["Score_Opp"],
                         first_downs_made: g["Offense_1stD"],
                         offensive_total_yards: g["Offense_TotYd"],
                         offensive_passing_yards: g["Offense_PassY"],
                         offensive_rushing_yards: g["Offense_RushY"],
                         turnovers_lost: g["Offense_TO"],
                         first_downs_allowed: g["Defense_1stD"],
                         total_yards_allowed: g["Defense_TotYd"],
                         passing_yards_allowed: g["Defense_PassY"],
                         rushing_yards_allowed: g["Defense_RushY"],
                         turnovers_gained: g["Defense_TO"])
      stats.save!
      if is_away
        game.away_team_stats = stats
      else
        game.home_team_stats = stats
      end
      game.save!
    end
  end
end

task :loadyears => :environment do
  require 'nokogiri'
  require 'open-uri'
  base_url = "http://www.pro-football-reference.com"
  threads = []
  ["db", "te", "rb", "p", "ol", "k", "wr", "lb", "qb", "dl"].each do |position_index|
    puts "Started on #{position_index}"
    position_doc = Nokogiri::HTML(open("http://www.pro-football-reference.com/players/#{position_index}index.htm"))
    links = position_doc.css("pre a")
    players = []
    links.each do |l|
      players << ["#{base_url}#{l.attribute("href").value}", l.content] if /^A/ === l.content
    end
    players.each do |player|
      if p=Player.find_by_url(player[0])
        puts "Skipped #{p.name}"
      else
        get_player_info(*player)
      end
    end
  end
end

task :loadgames => :environment do
  require 'nokogiri'
  require 'open-uri'
  Player.all.each do |player|
    url = player.url.sub(/\.htm$/, "/gamelog/")
    game_doc = Nokogiri::HTML(open(url))
    table = game_doc.css("#stats")
    puts "Starting on #{player.name}"
    scrape_game_table(table, player)
  end
end

def get_player_info(url, name)
  puts "Creating #{name}"
  doc = Nokogiri::HTML(open(url))
  if x = doc.css("p:contains('Position')").first
    position = x.content.match(/Position: (.*)\n/)[1].gsub("-", ",")
  else
    position = ""
  end
  player = Player.create(position: position, name: name, url: url)
  tables = ["#rushing_and_receiving", "#defense", "#passing", "#returns", "#kicking"]
  tables.each do |table|
    temp = doc.css(table)
    scrape_table(temp, table, player) unless temp.empty?
  end
end

def scrape_game_table(table, player)
  game_stats = get_table_hash(table)
  game_stats.each do |g|
    if g[""]=="@"
      away_team = g["Tm"]
      home_team = g["Opp"]
    else
      away_team = g["Opp"]
      home_team = g["Tm"]
    end
    pteam = Team.find_by_shortname(g["Tm"])
    away = Team.find_by_shortname(away_team)
    home = Team.find_by_shortname(home_team)
    begin
      game = Game.find_or_create_by(date: Date.parse(g["Date"]), year: g["Year"], week: g["G#"], away_team_id: away.id, home_team_id: home.id)
    rescue
      p g
      exit
    end
    pgame = PlayersGame.find_or_initialize_by(player_id: player.id, game_id: game.id, team_id: pteam.id)
    pgame.player_stats ||= PlayerStats.new
    pgame.player_stats.assign_attributes(rushing_attempts: g["Rushing_Att"],
                                  rushing_yards: g["Rushing_Yds"],
                                  rushing_touchdowns: g["Rushing_TD"],
                                  receptions: g["Receiving_Rec"],
                                  receiving_yards: g["Receiving_Yds"],
                                  receiving_touchdowns: g["Receiving_TD"],
                                  completions: g["Passing_Cmp"],
                                  attempts: g["Passing_Att"],
                                  passing_yards: g["Passing_Yds"],
                                  passing_touchdowns: g["Passing_TD"],
                                  interceptions_thrown: g["Passing_Int"],
                                  qb_rating: g["Passing_Rate"],
                                  solo_tackles: g["Sacks & Tackles_Tkl"],
                                  assist_tackles: g["Sacks & Tackles_Ast"],
                                  sacks: g["Sacks & Tackles_Sk"],
                                  passes_defended: g["Def Interceptions_PD"],
                                  interceptions: g["Def Interceptions_Int"],
                                  interception_touchdowns: g["Def Interceptions_TD"],
                                  fumbles: g["Fumbles_Fmb"],
                                  fumbles_forced: g["Fumbles_FF"],
                                  fumbles_recovered: g["Fumbles_FR"],
                                  fumbles_touchdowns: g["Fumbles_TD"],
                                  kick_return_attempts: g["Kick Returns_Rt"],
                                  kick_return_yards: g["Kick Returns_Yds"],
                                  kick_return_touchdowns: g["Kick Returns_TD"],
                                  punt_return_attempts: g["Punt Returns_Ret"],
                                  punt_return_yards: g["Punt Returns_Yds"],
                                  punt_return_touchdowns: g["Punt Returns_TD"],
                                  field_goals_made: g["Scoring_FGM"],
                                  field_goals_attempted: g["Scoring_FGA"],
                                  extra_points_made: g["Scoring_XPM"],
                                  extra_points_attempted: g["Scoring_XPA"],
                                  punts: g["Punting_Pnt"],
                                  punt_yards: g["Punting_Yds"])
    pgame.player_stats.save
    pgame.save
  end
end

def get_table_hash(table)
  id = table.attribute("id").value if table.present?
  head = table.children.css("thead")
  body = table.children.css("tbody")
  header = []
  stats = []
  head.children.css("tr").each do |tr|
    i=0
    tr.children.css("th").each do |th|
      if th.attributes["colspan"]
        x = th.attributes["colspan"].value.to_i
      else
        x = 1
      end
      x.times do
        header[i] ||= ""
        header[i] += "_" unless header[i].empty?
        header[i] += th.content
        i += 1
      end
    end
  end
  body.children.css("tr").each do |tr|
    if id != "stats" || /stats\.\d+/ === tr.attribute("id")
      temp = {}
      tr.children.css("td").each_with_index do |td,i|
        if ["Tm", "Opp"].include?(header[i])
          begin
            temp[header[i]] = td.children.css("a").attribute("href").value.match(/\/teams\/(\w+)\/\d+/)[1]
          rescue
            temp[header[i]] = nil
          end
        else
          temp[header[i]] = td.content
        end
      end
      stats << temp
    end
  end
  return stats
end

def scrape_table(table, id, player)
  year_stats = get_table_hash(table)
  last_year = nil
  year_stats.each do |year|
    this_year = year["Year"]
    last_year = this_year.to_i if this_year.present?
    if year["Tm"].present?
      team = Team.find_by_shortname(year["Tm"])
      if !team
        p year["Tm"]
        return
      end
      pteam = PlayersTeam.find_or_initialize_by(player_id: player.id, team_id: team.id)
      pteam.start = last_year if !pteam.start || last_year < pteam.start
      pteam.end = last_year if !pteam.end || last_year > pteam.end
      pteam.save
    end
    pyear = PlayersYear.find_or_initialize_by(player_id: player.id, year: year["Year"].gsub(/\W/,''))
    pyear.player_stats ||= PlayerStats.new
    case id
    when "#rushing_and_receiving"
      pyear.player_stats.assign_attributes(rushing_attempts: year["Rushing_Att"],
                                    rushing_yards: year["Rushing_Yds"],
                                    rushing_touchdowns: year["Rushing_TD"],
                                    receptions: year["Receiving_Rec"],
                                    receiving_yards: year["Receiving_Yds"],
                                    receiving_touchdowns: year["Receiving_TD"])
    when "#passing"
      pyear.player_stats.assign_attributes(completions: year["Cmp"],
                                    attempts: year["Att"],
                                    passing_yards: year["Yds"],
                                    passing_touchdowns: year["TD"],
                                    interceptions_thrown: year["Int"],
                                    times_sacked: year["Sk"],
                                    qb_rating: year["Rate"])
    when "#defense"
      pyear.player_stats.assign_attributes(solo_tackles: year["Tackles_Tkl"],
                                    assist_tackles: year["Tackles_Ast"],
                                    sacks: year["Sk"],
                                    passes_defended: year["Def Inteceptions_PD"],
                                    interceptions: year["Def Inteceptions_Int"],
                                    interception_touchdowns: year["Def Interceptions_TD"],
                                    fumbles: year["Fumbles_Fmb"],
                                    fumbles_forced: year["Fumbles_FF"],
                                    fumbles_recovered: year["Fumbles_FR"],
                                    fumbles_touchdowns: year["Fumbles_TD"])
    when "#returns"
      pyear.player_stats.assign_attributes(kick_return_attempts: year["Kick Returns_Rt"],
                                    kick_return_yards: year["Kick Returns_Yds"],
                                    kick_return_touchdowns: year["Kick Returns_TD"],
                                    punt_return_attempts: year["Punt Returns_Ret"],
                                    punt_return_yards: year["Punt Returns_Yds"],
                                    punt_return_touchdowns: year["Punt Returns_TD"])
    when "#kicking"
      pyear.player_stats.assign_attributes(field_goals_made: year["Tot_FGM"],
                                    field_goals_attempted: year["Tot_FGA"],
                                    extra_points_made: year["PAT_XPM"],
                                    extra_points_attempted: year["PAT_XPA"],
                                    punts: year["Punting_Pnt"],
                                    punt_yards: year["Punting_Yds"])
    end
    pyear.player_stats.save
    pyear.save
  end
end
