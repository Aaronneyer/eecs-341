task :loaddata do
  require 'nokogiri'
  require 'open-uri'
  doc = Nokogiri::HTML(open("http://www.pro-football-reference.com/players/J/JohnCh04.htm"))
  tables = ["#rushing_and_receiving", "#defense", "#passing", "#returns", "#kicking"]
  tables.each do |table|
    temp = doc.css(table)
    p scrape_table(temp) unless temp.empty?
  end
end

def scrape_table(table)
  head = table.children.css("thead")
  body = table.children.css("tbody")
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
  year_stats
end
