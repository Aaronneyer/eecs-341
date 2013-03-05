# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Eecs341::Application.load_tasks

task :loaddata do
  rows = CSV.parse(File.open("nfl.csv").read, quote_char: "|") #Need quote char to be something not used
  rows.each do |row|
    desc = row[11]
    primary_player, play_type = desc.match(/^(\(\d{,2}:\d{,2}\))?\s*(\w+\.\w+)\s+(\w+)/)[1..2]
    if play_type=="pass"
      #More logic and shit here
      Play.create(player: primary_player, type: "Pass")
    end
  end
end
