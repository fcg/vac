require 'Nokogiri'
require 'open-uri'
require 'openssl'
require 'sqlite3'
require 'csv'
require 'net/http'

CEILINGS   = "//*[@id='tab-content-3']/table"
CEILINGTRS = "//*[@id='tab-content-3']/table/tbody/tr"
TURL = "http://www.border.gov.au/Trav/Work/Skil"

F1617 = "zdb-06" # 每次修改这里

DATADIR = "../_data/zdb/"

POSTDIR = "../_posts/"

=begin
	190 一个表，每次邀请周期一个csv，同时更新数据库，csv 计算并记录两次之间的新增邀请。对应 post。
	全部类别一个csv，记录每次情况，对应 post 。
=end

THEAD=<<-TH

<table border = "1" cellpadding="2" cellspacing="0"><tbody>
<tr>
<th><a href="../anzsco">ANZSCO</a></th>
<th><a href="../sol">SOL</a>职业名称 - FLYabroad</th>
<th>配额计划</th>
<th>已使用配额</th>
</tr>
TH

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

def download_skillselect()

	open('skillselect.html', 'wb') do |file|
	  puts "download skillselect html"
	  file << open(TURL, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}).read
	end

end

def get_doc(url)

	ua = 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0.1) Gecko/20100101 Firefox/9.0.1'
	charset = 'utf-8'

  # html = open("vic-graduates.html")
	html = open(url, 'User-Agent' => ua)
	doc = Nokogiri::HTML::parse(html, nil, charset)
end

def post()

# 读数据库，同时读 csv 获取最新的当月州担保数据，全部数据（2016/17 total activity ）和190具体个月累计数据。

end

# buildceilinghtml()

def create190table()

	# ACT NSW	NT	Qld	SA	Tas.	Vic.	WA	Total
  db = SQLite3::Database.open "csol.db"

    # Create a table
    rows = db.execute <<-SQL
      create table eoi190 (
      Id INTEGER PRIMARY KEY AUTOINCREMENT,
      ACT INTERGER DEFAULT NULL,
      NSW INTERGER DEFAULT NULL,
      NT INTERGER DEFAULT NULL,
			Qld INTERGER DEFAULT NULL,
			SA  INTERGER DEFAULT NULL,
			Tas	 INTERGER DEFAULT NULL,
			Vic	  INTERGER DEFAULT NULL,
			WA INTERGER DEFAULT NULL,
			Total INTERGER DEFAULT NULL,
			updated TEXT DEFAULT NULL
      );
    SQL

    db.close

end

def get_and_save()

	db = SQLite3::Database.open "csol.db"

	html = open("skillselect.html")
  charset = 'utf-8'

  doc = Nokogiri::HTML::parse(html, nil, charset)

	table = getTable()

  trs = table.css("tbody>tr")

	_190tds = trs[0].css("td")

	eoi190 = Array.new

	_190tds.each_with_index do  |td, index|

		eoi190.push getTdText(td).strip.gsub(",","").to_i if index > 0
	end

	eoi190.push "2016-07-31"
	db.execute("insert into eoi190 (ACT, NSW, NT, Qld, SA, Tas, Vic, WA, Total, updated) VALUES (?,?,?,?,?,?,?,?,?,?)",eoi190)

	# Skilled – Nominated (subclass 190) visa
	# Skilled – Regional (Provisional) (subclass 489) visa
	# Business Innovation and Investment (subclass 188) visa
	# Business Talent (Permanent) (subclass 132) visa
	# Total

		classArray = [190,489,188,132,'Total']

	CSV.open("#{DATADIR}#{F1617}.csv", "w") do |csv|
		csv << %w(Class ACT NSW NT Qld SA Tas Vic WA Total)

	  trs.each_with_index do |tr, rindex|
			subclass = Array.new
			tds = tr.css("td")

			tds.each_with_index do  |td, dindex|
				subclass.push classArray[rindex] if dindex == 0
				subclass.push getTdText(td).strip.gsub(",","").to_i if dindex > 0
			end

			csv << subclass
	  end
	end

end

def getTdText(td)

	div =  td.at_css("div")

	text = div.nil? ? td.text.strip : div.text.strip

end

def getTable()

	doc = get_doc(TURL)

	table = doc.css(".table-100.small").first

	# puts table

end

# getTable()
# create190table()
# download_skillselect()
get_and_save()
# get_and_save()
