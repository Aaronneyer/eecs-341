task :loaddata => ["db:drop", "db:migrate", :loadteams, :loadyears, :loadgames]

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

task :loadyears => :environment do
  require 'nokogiri'
  require 'open-uri'
  base_url = "http://www.pro-football-reference.com"
  ["db", "te", "rb", "p", "ol", "k", "wr", "lb", "qb", "dl"].each do |position_index|
    puts "Started on #{position_index}"
    position_doc = Nokogiri::HTML(open("http://www.pro-football-reference.com/players/#{position_index}index.htm"))
    links = position_doc.css("pre a")
    players = []
    links.each do |l|
      players << ["#{base_url}#{l.attribute("href").value}", l.content]
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
    position = x.content.match(/Position: (.*)\n/)[1].split("-").select{|p| ["DB","TE", "RB", "P", "OL", "K", "WR", "LB", "QB", "DL"].include?(p)}.join(",")
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
  head = table.children.css("thead")
  body = table.children.css("tbody")
  header = []
  game_stats = []
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
    if /stats\.\d+/ === tr.attribute("id")
      temp = {}
      tr.children.css("td").each_with_index do |td,i|
        if ["Tm", "Opp"].include?(header[i])
          temp[header[i]] = td.children.css("a").attribute("href").value.match(/\/teams\/(\w+)\/\d+/)[1]
        else
          temp[header[i]] = td.content
        end
      end
      game_stats << temp
    end
  end
  game_stats.each do |g|
    if g[""]=="@"
      away_team = g["Tm"]
      home_team = g["Opp"]
    else
      away_team = g["Opp"]
      home_team = g["Tm"]
    end
    if /^W/ === g["Result"]
      winning_team = g["Tm"]
    elsif /^L/ === g["Result"]
      winning_team = g["Opp"]
    elsif /^T/ === g["Result"]
      winning_team = nil
    end
    winning = Team.find_by_shortname(winning_team)
    winning = winning.id if winning
    away = Team.find_by_shortname(away_team)
    home = Team.find_by_shortname(home_team)
    game = Game.find_or_create_by(date: g["Date"], year: g["Year"], week: g["G#"], away_team_id: away.id, home_team_id: home.id, winning_team_id: winning)
    pgame = PlayersGame.find_or_initialize_by(player_id: player.id, game_id: game.id)
    pgame.stats ||= Stats.new
    pgame.stats.assign_attributes(rushing_attempts: g["Rushing_Att"],
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
    pgame.stats.save
    pgame.save
  end
end

def scrape_table(table, id, player)
  head = table.children.css("thead")
  body = table.children.css("tbody")
  header = []
  year_stats = []
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
    temp = {}
    tr.children.css("td").each_with_index do |td,i|
      if header[i]=="Tm"
        begin
          temp["Tm"] = td.children.css("a").attribute("href").value.match(/\/teams\/(\w+)\/\d+/)[1]
        rescue
          if !(/\dTM/ === td.content)
            p td
            raise "Something went wrong"
          else
            temp["Tm"] = nil
          end
        end
      else
        temp[header[i]] = td.content
      end
    end
    year_stats << temp
  end
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
    pyear.stats ||= Stats.new
    case id
    when "#rushing_and_receiving"
      pyear.stats.assign_attributes(rushing_attempts: year["Rushing_Att"],
                                    rushing_yards: year["Rushing_Yds"],
                                    rushing_touchdowns: year["Rushing_TD"],
                                    receptions: year["Receiving_Rec"],
                                    receiving_yards: year["Receiving_Yds"],
                                    receiving_touchdowns: year["Receiving_TD"])
    when "#passing"
      pyear.stats.assign_attributes(completions: year["Cmp"],
                                    attempts: year["Att"],
                                    passing_yards: year["Yds"],
                                    passing_touchdowns: year["TD"],
                                    interceptions_thrown: year["Int"],
                                    times_sacked: year["Sk"],
                                    qb_rating: year["Rate"])
    when "#defense"
      pyear.stats.assign_attributes(solo_tackles: year["Tackles_Tkl"],
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
      pyear.stats.assign_attributes(kick_return_attempts: year["Kick Returns_Rt"],
                                    kick_return_yards: year["Kick Returns_Yds"],
                                    kick_return_touchdowns: year["Kick Returns_TD"],
                                    punt_return_attempts: year["Punt Returns_Ret"],
                                    punt_return_yards: year["Punt Returns_Yds"],
                                    punt_return_touchdowns: year["Punt Returns_TD"])
    when "#kicking"
      pyear.stats.assign_attributes(field_goals_made: year["Tot_FGM"],
                                    field_goals_attempted: year["Tot_FGA"],
                                    extra_points_made: year["PAT_XPM"],
                                    extra_points_attempted: year["PAT_XPA"],
                                    punts: year["Punting_Pnt"],
                                    punt_yards: year["Punting_Yds"])
    end
    pyear.stats.save
    pyear.save
  end
end
