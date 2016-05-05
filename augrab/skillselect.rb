require 'Nokogiri'
require 'open-uri'
require 'openssl'
require 'sqlite3'
require 'csv'
require 'net/http'

CEILINGS   = "//*[@id='tab-content-3']/table"
CEILINGTRS = "//*[@id='tab-content-3']/table/tbody/tr"
TURL = "https://www.border.gov.au/Busi/Empl/skillselect"

THEAD=<<-TH

<table border = "1" cellpadding="2" cellspacing="0"><tbody>
<tr>
<th><a href="../anzsco">ANZSCO</a></th>
<th><a href="../sol">SOL</a>职业名称 - FLYabroad</th>
<th>配额计划</th>
<th>已使用配额</th>
</tr>
TH

# OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

def download_doc(url)

	open('skillselect.html', 'wb') do |file|
	  puts "download skillselect html"
	  file << open(url, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}).read
	end

end

def get_doc(url)

	ua = 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0.1) Gecko/20100101 Firefox/9.0.1'
	charset = 'utf-8'

  # html = open("vic-graduates.html")
	html = open(url, 'User-Agent' => ua)
	doc = Nokogiri::HTML::parse(html, nil, charset)
end

def buildceilinghtml()
  db = SQLite3::Database.open "csol.db"
  rows = db.execute("select * from ceilings order by result desc")

  trarr = Array.new

  rows.each do |row|
    anz = row[1]
    en = row[2]
    cn = row[3]
    ceiling = row[4]
    result = row[5]
    bbs = row[6]

    trarr.push "<tr><td><a href=\"http://bbs.fcgvisa.com/t/#{bbs}\" target=\"_blank\">#{anz}</a></td><td>#{cn} / #{en}</td><td>#{ceiling}</td><td>#{result}</td></tr>"

  end

  puts THEAD + trarr.join("") + "</tbody></table>"

end

# buildceilinghtml()

def createceilingtable()

  db = SQLite3::Database.open "csol.db"

    # Create a table
    rows = db.execute <<-SQL
      create table ceilings (
      Id INTEGER PRIMARY KEY AUTOINCREMENT,
      anzsco4 TEXT DEFAULT NULL,
      nameen TEXT DEFAULT NULL,
      nameen TEXT DEFAULT NULL,
      ceiling INTERGER DEFAULT NULL,
      result INTERGER DEFAULT NULL,
      bbsid INTERGER DEFAULT NULL
      );
    SQL

    db.close

end

def get_and_save()

  # createceilingtable()
  db = SQLite3::Database.open "csol.db"

	download_doc(TURL)

  html = open("skillselect.html")
  charset = 'utf-8'
  doc = Nokogiri::HTML::parse(html, nil, charset)

  table = doc.css(".table-100").last

  trs = table.css("tbody>tr")

  trs.each do |tr|
    td1anzsco4 = tr.xpath("td[1]").inner_text.gsub(/\u00A0/,"").strip
    td2nameen  = tr.xpath("td[2]").inner_text.gsub(/\u00A0/,"").strip
    td3ceiling  = tr.xpath("td[3]").inner_text.gsub(/\u00A0/,"").strip.to_i
    td4result   = tr.xpath("td[4]").inner_text.gsub(/\u00A0/,"").strip.to_i

    # puts td1anzsco4

    db.execute("insert into ceilings (anzsco4,nameen,ceiling,result) VALUES (?,?,?,?)",[td1anzsco4,td2nameen,td3ceiling,td4result])

  end

end

# get_and_save()
