require 'Nokogiri'
require 'open-uri'
require 'haml'
require 'reverse_markdown'
require "sqlite3"

def parsenewee()

  ua = 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0.1) Gecko/20100101 Firefox/9.0.1'
  url = 'http://www.cic.gc.ca/english/department/mi/'
  charset = 'utf-8'
  html = open(url, 'User-Agent' => ua)

  # html = open("miee.html")
  doc = Nokogiri::HTML::parse(html, nil, charset)

  invitationsxpath = ".//*[@id='mi-pr-express']/p[5]/strong[4]/text()"
  rankxpath = ".//*[@id='mi-pr-express']/p[6]/strong[3]/text()"
  datexpath = ".//*[@id='mi-pr-express']/p[5]/strong[2]/span/text()"
  mieexpath = ".//*[@id='mi-pr-express']"

  datecss = ".nowrap"

  miee = doc.xpath(mieexpath).to_html
  invitations = doc.xpath(invitationsxpath).to_s.delete(',').to_i
  rank = doc.xpath(rankxpath).to_s.delete(',').to_i
  # eedate = doc.xpath(datexpath).to_s
  eedate = doc.css(datecss).last.inner_text.to_s.gsub("–","").strip

  p eedate

  # d = Date.parse(date).strftime('%F')

  ReverseMarkdown.config do |config|
    config.unknown_tags     = :bypass
    config.github_flavored  = true
    config.tag_border  = ''
  end

  miBody = ReverseMarkdown.convert miee

  db = SQLite3::Database.open "eedraws.db"

  maxnum = db.execute("select MAX(TotalNum) from eedraws").first[0]
  inyear = db.execute("select NumInYear from eedraws where TotalNum='#{maxnum}'").first[0] + 1
  totalnum = maxnum + 1

  # ymdDate = Date.parse(eedate[0]).strftime('%F')

  ymdDate = Date.strptime(eedate, "%b %d, %Y").strftime("%Y-%m-%d")

  row = [ymdDate,invitations,rank,totalnum,inyear,miBody]

  db.execute("INSERT INTO eedraws (EEDate, EEinvitations,EErank,TotalNum,NumInYear,MIBody)
          VALUES (?, ?,?,?,?,?)", row)

  db.close

end

parsenewee()
