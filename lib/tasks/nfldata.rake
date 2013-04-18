task :loaddata => :environment do
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

def get_player_info(url, name)
  doc = Nokogiri::HTML(open(url))
  position = doc.css("p:contains('Position')").first.content.match(/Position:\ (.*)\n/)[1]
  player = Player.create(position: position, name: name, url: url)
  tables = ["#rushing_and_receiving", "#defense", "#passing", "#returns", "#kicking"]
  tables.each do |table|
    temp = doc.css(table)
    scrape_table(temp, table, player) unless temp.empty?
  end
  puts "Created #{player.name}"
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
      temp[header[i]] = td.content
    end
    year_stats << temp
  end
  year_stats.each do |year|
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
