require 'Nokogiri'
require 'open-uri'
require 'openssl'
require 'sqlite3'
require 'csv'
require 'net/http'

CEILINGS   = "//*[@id='tab-content-3']/table".freeze
CEILINGTRS = "//*[@id='tab-content-3']/table/tbody/tr".freeze
TURL = "http://www.border.gov.au/Trav/Work/Skil".freeze

### 注意，每次修改这里为当前发布数据月份的最后一天
F1617 = '2017-05-31'.freeze
MONTH = '2017-05'.freeze # 每次修改这里

T190CSV = '190-1617'.freeze

ZDBTOTAL = 'zdb-total-1617'.freeze

DATADIR = '../_data/zdb/'.freeze

POSTDIR = '../_posts/'.freeze

# 	190 一个表，每次邀请周期一个csv，同时更新数据库，csv 计算并记录两次之间的新增邀请。对应 post。
# 	全部类别一个csv，记录每次情况，对应 post 。

T190 = <<-TH.freeze

### 飞出国 2016-2017 年度各州 190 州担保数据记录

下面数据只针对 2016-2017 年度澳洲 190 州担保各州担保数据。

<table border = "1" cellpadding="1" cellspacing="0">
<tr>
<th>月份</th>
<th>堪培拉</th>
<th>新州</th>
<th>北领地</th>
<th>昆州</th>
<th>南澳</th>
<th>塔州</th>
<th>维州</th>
<th>西澳</th>
<th>总计</th>
</tr>
{% for zdb in site.data.zdb.190-1617 %}
<tr>
<td> {{ zdb.updated }} </td>
<td> {{ zdb.ACT }} </td>
<td> {{ zdb.NSW }} </td>
<td> {{ zdb.NT }} </td>
<td> {{ zdb.Qld }} </td>
<td> {{ zdb.SA }} </td>
<td> {{ zdb.Tas }} </td>
<td> {{ zdb.Vic }} </td>
<td> {{ zdb.WA }} </td>
<td> {{ zdb.Total }} </td>
</tr>
{% endfor %}
</table>
TH

TMONTH = <<-TBODY.freeze
<table border = "1" cellpadding="1" cellspacing="0">
  <tr>
    <th>类别</th>
    <th>堪培拉</th>
    <th>新州</th>
    <th>北领地</th>
    <th>昆州</th>
    <th>南澳</th>
    <th>塔州</th>
    <th>维州</th>
    <th>西澳</th>
    <th>总计</th>
  </tr>
{% for zdb in site.data.zdb.#{F1617} %}
<tr>
<td> {{ zdb.Class }} </td>
<td> {{ zdb.ACT }} </td>
<td> {{ zdb.NSW }} </td>
<td> {{ zdb.NT }} </td>
<td> {{ zdb.Qld }} </td>
<td> {{ zdb.SA }} </td>
<td> {{ zdb.Tas }} </td>
<td> {{ zdb.Vic }} </td>
<td> {{ zdb.WA }} </td>
<td> {{ zdb.Total }} </td>
</tr>
{% endfor %}
</table>
TBODY

FRONTSTR = <<-YAML.freeze
---
layout: post
title:  "#{MONTH} 澳洲州担保邀请数据"
date:   #{F1617} 23:56:00  +0800
categories: gsm
---

飞出国澳洲 SkillSelect 2016-2017 年度州担保邀请数据统计。

## #{MONTH} 澳洲州担保邀请数据

YAML

ENDSTR = <<-ENDS.freeze

更多请参考飞出国论坛： [2016-2017 年度澳洲州担保邀请记录](http://bbs.fcgvisa.com/t/2016-2017/18110/) 。

需要获得相关移民及出国签证申请帮助可以联系飞出国微信（fcgvisabbs）： <a href="http://flyabroad.me/contact" target="_blank">http://flyabroad.me</a>。

> 以上内容由`飞出国香港`（<a href="http://flyabroad.hk/" target="_blank">flyabroad.hk</a>）整理完成，转载请保留并注明出处。

ENDS

# Skilled – Nominated (subclass 190) visa
# Skilled – Regional (Provisional) (subclass 489) visa
# Business Innovation and Investment (subclass 188) visa
# Business Talent (Permanent) (subclass 132) visa
# Total

CLASSARRAY = [190, 489, 188, 132, 'Total'].freeze

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

def download_skillselect
  open('skillselect.html', 'wb') do |file|
    puts 'download skillselect html'
    file << open(TURL, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE).read
  end
end

def get_doc(url)
  ua = 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0.1) Gecko/20100101 Firefox/9.0.1'
  charset = 'utf-8'

  # html = open("vic-graduates.html")
  html = open(url, 'User-Agent' => ua)
  doc = Nokogiri::HTML.parse(html, nil, charset)
end

def open_doc
  html = open('skillselect.html')
  charset = 'utf-8'

  doc = Nokogiri::HTML.parse(html, nil, charset)
end

def post
  # 读数据库，同时读 csv 获取最新的当月州担保数据，全部数据（2016/17 total activity ）和190具体个月累计数据。
	File.open("#{POSTDIR}#{F1617}-State-Territory-nominations.md", 'w') do |file|

		content = FRONTSTR + TMONTH + T190 + ENDSTR

		file.write content

	end
end

# buildceilinghtml()

def create190table
  # ACT NSW	NT	Qld	SA	Tas.	Vic.	WA	Total
  db = SQLite3::Database.open 'csol.db'

  # Create a table
  rows = db.execute <<-SQL
      create table eoi190 (
      Id INTEGER PRIMARY KEY AUTOINCREMENT,
      ACT INTERGER DEFAULT NULL,
      NSW INTERGER DEFAULT NULL,
      NT INTERGER DEFAULT NULL,
			Qld INTERGER DEFAULT NULL,
			SA  INTERGER DEFAULT NULL,
			Tas	INTERGER DEFAULT NULL,
			Vic	INTERGER DEFAULT NULL,
			WA INTERGER DEFAULT NULL,
			Total INTERGER DEFAULT NULL,
			updated TEXT DEFAULT NULL
      );
    SQL

  db.close
end

def save_month
  db = SQLite3::Database.open 'csol.db'

  table = getMonthTable

  trs = table.css('tbody>tr')

  _190tds = trs[0].css('td')

  eoi190 = []

  _190tds.each_with_index do |td, index|
    eoi190.push getTdText(td).strip.delete(',').to_i if index > 0
  end

  eoi190.push MONTH
  db.execute('insert into eoi190 (ACT, NSW, NT, Qld, SA, Tas, Vic, WA, Total, updated) VALUES (?,?,?,?,?,?,?,?,?,?)', eoi190)

	# 190-1617 db

	rows = db.execute("select ACT,NSW,NT,Qld,SA,Tas,Vic,WA,Total,updated from eoi190 order by updated desc")

	CSV.open("#{DATADIR}#{T190CSV}.csv", 'w') do |csv|
		csv << %w(ACT NSW NT Qld SA Tas Vic WA Total updated)

		rows.each do |row|
				csv << row
		end

		sum = db.execute("select SUM(ACT),SUM(NSW),SUM(NT),SUM(Qld),SUM(SA),SUM(Tas),SUM(Vic),SUM(WA),SUM(Total),'飞出国' from eoi190").first

		csv << sum
	end
end

def save_month_CSV

    table = getMonthTable
    trs = table.css('tbody>tr')
    	# 具体月份 web
    CSV.open("#{DATADIR}#{F1617}.csv", 'w') do |csv|
    csv << %w(Class ACT NSW NT Qld SA Tas Vic WA Total)

    trs.each_with_index do |tr, rindex|
      subclass = []
      tds = tr.css('td')

      tds.each_with_index do |td, dindex|
        subclass.push CLASSARRAY[rindex] if dindex.zero?
        subclass.push getTdText(td).strip.delete(',').to_i if dindex > 0
      end
      p subclass
      csv << subclass
    end
  end

end

def save_total
  table = getTotalTable

  trs = table.css('tbody>tr')

  CSV.open("#{DATADIR}#{ZDBTOTAL}.csv", 'w') do |csv|
    csv << %w(Class ACT NSW NT Qld SA Tas Vic WA Total)

    trs.each_with_index do |tr, rindex|
      # next if rindex.zero?
      subs = []
      tds = tr.css('td')

      tds.each_with_index do |td, dindex|
        subs.push CLASSARRAY[rindex] if dindex.zero?
        subs.push getTdText(td).strip.delete(',').to_i if dindex > 0
      end
      p subs
      csv << subs
    end
  end
end

def getTdText(td)
  div = td.at_css('div')

  text = div.nil? ? td.text.strip : div.text.strip
end

def getMonthTable
  doc = open_doc

  table = doc.css('.table-100.small').first
end

def getTotalTable
  doc = open_doc

  table = doc.css('.table-100.small')[1]
end

download_skillselect
save_month
save_month_CSV
save_total
post

# getTotalTable()
# create190table()
# download_skillselect()
# get_and_save
# get_and_save()
