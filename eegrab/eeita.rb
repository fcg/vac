require 'Nokogiri'
require 'open-uri'
require 'haml'
require 'reverse_markdown'
require "sqlite3"

def parseDraws()

  ua = 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0.1) Gecko/20100101 Firefox/9.0.1'
  url = 'http://www.cic.gc.ca/english/department/mi/ita.asp'
  charset = 'utf-8'
  html = open(url, 'User-Agent' => ua)
  doc = Nokogiri::HTML::parse(html, nil, charset)

  detailsxpath = "html/body/div/div/main/section/details"
  invitationsxpath = "p[5]/strong[4]/text()"
  rankxpath = "p[6]/strong[3]/text()"

  ReverseMarkdown.config do |config|
    config.unknown_tags     = :bypass
    config.github_flavored  = true
    config.tag_border  = ''
  end

  begin

  db = SQLite3::Database.open "eedraws.db"

  details = doc.xpath(detailsxpath)

  arr = Array.new

  details.each do |detail|
    miBody = ReverseMarkdown.convert detail.to_html
    draw = detail.xpath(".//*/h3/text()").to_s # #1 – January 31, 2015
    h3line = draw.strip.split(" – ")
    total = h3line[0].sub('#','')
    eedate = h3line[1]
    invitations = detail.xpath(invitationsxpath).to_s
    rank = detail.xpath(rankxpath).to_s

    arr << [eedate,invitations,rank,total,total,miBody]

    end

    arr.sort_by! do |item| #note the exclamation mark
        item[3].to_i
    end

    # p arr

    arr.each do |row|

      db.execute("INSERT INTO eedraws (EEDate, EEinvitations,EErank,TotalNum,NumInYear,MIBody)
              VALUES (?, ?,?,?,?,?)", row)
    end

  rescue Exception => e
    puts e.message
  ensure
    begin
      db.close
    rescue Exception => e
      puts e.message
    end
  end

  # invitations = doc.xpath(invitationsxpath).to_s
  # rank = doc.xpath(rankxpath).to_s
  # date = doc.xpath(datexpath).to_s
  #
  # d = Date.parse(date).strftime('%F')
end

def createEEdrawsDB()
  # Open a database
  db = SQLite3::Database.new "eedraws.db"

  # Create a table
  rows = db.execute <<-SQL
    create table eedraws (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    EEDate TEXT DEFAULT NULL UNIQUE,
    EEinvitations INTEGER DEFAULT NULL,
    EErank INTEGER DEFAULT NULL,
    TotalNum INTEGER DEFAULT NULL,
    NumInYear INTEGER DEFAULT NULL,
    MIBody TEXT DEFAULT NULL
    );
  SQL

  db.close

end

# createEEdrawsDB()
# parseDraws()

def insertEEdrawsLine(drawValue)

  db = SQLite3::Database.open "eedraws.db"

  begin

    db.execute("INSERT INTO eedraws (EEDate, EEinvitations,EErank,MIBody,TotalNum,NumInYear)
            VALUES (?, ?,?,?,?,?)", drawValue)
  rescue Exception => e
    puts e.message
  ensure
    begin
      db.close
    rescue Exception => e
      puts e.message
    end
  end
end
