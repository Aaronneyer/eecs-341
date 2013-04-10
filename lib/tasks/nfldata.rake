task :loaddata do
  require 'nokogiri'
  require 'open-uri'
  doc = Nokogiri::HTML(open("http://www.pro-football-reference.com/players/J/JohnCh04.htm"))
  rushing_and_receiving_table = doc.css("#rushing_and_receiving")
  head = rushing_and_receiving_table.children.css("thead")
  body = rushing_and_receiving_table.children.css("tbody")
  header = []
  year_stats = []
  head.children.css("tr").each do |tr|
    i=0
    tr.children.css("th").each do |th|
      if th.attributes["colspan"]
        th.attributes["colspan"].value.to_i.times do
          header[i] ||= ""
          header[i] += "_" unless header[i].empty?
          header[i] += th.content
          i += 1
        end
      else
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
  p year_stats
end

