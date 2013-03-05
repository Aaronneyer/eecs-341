task :loaddata do
  require 'csv'
  rows = CSV.parse(File.open("nfl.csv").read, quote_char: "|") #Need quote char to be something not used
  
  rows[1..-1].each do |row|
    gameid = row[0]
    desc = row[11]
    primary_player, play_type, remaining = desc.match(/^(\(\d{,2}:\d{,2}\))? ?(\([\w\s]+\) )?(PENALTY on \w+-)?(\w+\.\s?[\w-]+) (\w+) (.*)/)[4..6]
    gameid = row[0]
    #game = Game.find_by_gameid(gameid)
    if play_type=="pass"
      if remaining.match(/^incomplete/)
        puts "Player: #{primary_player}, Type: Incomplete, Game: #{gameid}"
        #Play.create(player: primary_player, type: "incomplete_pass", game: game)
      elsif remaining.match(/INTERCEPTED/)
        secondary_player = remaining.match(/INTERCEPTED by (\w+\.\s?[\w-]+)/)[1]
        puts "Player: #{primary_player}, Type: Interception thrown"
        puts "Player: #{secondary_player}, Type: Intercepted"
        #Play.create(player: primary_player, type: "interception_thrown", game:
        #
      elsif remaining.match(/TOUCHDOWN/)
        newmatch = remaining.match(/(\w+ )+to\s(\w+\.\s?[\w-]+)\sfor\s(\d+)\syards\sTOUCHDOWN/)
        secondary_player = newmatch[2]
        yards = newmatch[3]
        puts "Player: #{primary_player}, Type: passing_td, Yards: #{yards}, Game: #{gameid}"
        puts "Player: #{secondary_player}, Type: receiving_td, Yards: #{yards}, Game: #{gameid}"
      else
        newmatch = remaining.match(/(\w+ )+to\s(\w+\.\s?[\w-]+)\s(to|(pushed|ran) ob at)\s?\w*\s\d+\sfor\s(-?\d+\syards?|no gain)/)
        secondary_player = newmatch[2]
        yards = newmatch[5]
        puts "Player: #{primary_player}, Type: Completion, Yards: #{yards}, Game: #{gameid}"
        puts "Player: #{secondary_player}, Type: Reception, Yards: #{yards}, Game: #{gameid}"
        #Play.create(player: primary_player, type: "complete_pass", game: game, yards: yards)
        #Play.create(player: secondary_player, type: "reception", game: game, yards: yards)
      end
    end
  end
end
