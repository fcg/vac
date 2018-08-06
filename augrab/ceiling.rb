require 'Nokogiri'
require 'open-uri'
require 'openssl'
require 'sqlite3'
require 'csv'
require 'net/http'
require "yaml"
require 'date'
require 'reverse_markdown'

CEILINGS   = ".//*[@id='tab-content-3']/table"
CEILINGTRS = ".//*[@id='tab-content-3']/table/tbody/tr"

TURL = "https://www.homeaffairs.gov.au/Busi/Empl/skillselect"

CURRENTFN = "2018-07-11"  # 每次有新更新先修改这里
F1819 = "ceilling-18-19"
DATADIR = "../_data/sol/"
POSTDIR = "../_posts/"

FOOT =<<-FT

[荷兰库拉索移民](http://www.flyabroad.hk/curacao)适合技术移民无望或技术移民遥遥无期的高知中产阶层人群。一套提供持续较高收益的国际房产（酒店公寓），一个说走就走的国际身份（无移民监），一个中产阶层与欧洲强国护照最接近的移民项目（荷兰护照）。

需要获得相关移民及出国签证申请帮助可以联系飞出国： <a href="http://flyabroad.me/contact" target="_blank">http://flyabroad.me/contact/</a>。

> 以上内容由`飞出国香港`（<a href="http://flyabroad.hk/" target="_blank">flyabroad.hk</a>）整理完成，转载请保留并注明出处。
FT

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

def theTrs()

  ua = 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0.1) Gecko/20100101 Firefox/9.0.1'
  charset = 'utf-8'

  html = open(TURL, 'User-Agent' => ua)

  doc = Nokogiri::HTML::parse(html, nil, charset)

  table = doc.css("table").last
  trs = table.css("tbody/tr")

end

def updateceilingslog(_month)  # jullog 

  trs = theTrs()

  db = SQLite3::Database.open "csol.db"

  trs.each do |tr|
    next if tr.xpath("td").empty?
    next if tr.xpath("td[1]").empty?

    td1anzsco4 = tr.xpath("td[1]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip
    td2nameen  = tr.xpath("td[2]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip
    td3ceiling  = tr.xpath("td[3]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip.to_i
    td4result   = tr.xpath("td[4]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip.to_i

    db.execute("update ceilingslog set #{_month} = #{td4result} where anzsco4 = #{td1anzsco4}")

  end

end

def upateceilling()

  trs = theTrs()

  db = SQLite3::Database.open "csol.db"

    trs.each do |tr|

      next if tr.xpath("td").empty?
      next if tr.xpath("td[1]").empty?

      td1anzsco4 = tr.xpath("td[1]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip
      td2nameen  = tr.xpath("td[2]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip
      td3ceiling  = tr.xpath("td[3]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip.to_i
      td4result   = tr.xpath("td[4]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip.to_i

      crow = db.execute("select anzsco4, bbsid, nameen, namecn, ceiling, result, updated from ceilings where anzsco4 = ?",td1anzsco4)

      lastresutl = crow[0][5]
      lastupdate = crow[0][6]

      change = td4result - lastresutl

      p "#{td1anzsco4}:#{lastresutl}:#{td4result}:#{change}"

      updated = Time.now.strftime("%Y-%m-%d")

      db.execute("update ceilings set result = ? , change = ?, updated = ? where anzsco4 = ?", [td4result, change, updated, td1anzsco4]) if lastupdate != updated

  end

end

def postmonthcsv()
  db = SQLite3::Database.open "csol.db"

  rows = db.execute("select anzsco4, bbsid, nameen, namecn, ceiling, result, change, ceiling - result as remain from ceilings")

  CSV.open("#{DATADIR}#{CURRENTFN}.csv", "w") do |csv|
    csv << %w(anzsco4 bbsid nameen namecn ceiling result change remain)
    rows.each do |row|
      csv << row
    end
  end

end

def updatecsv()

  db = SQLite3::Database.open "csol.db"

  rows = db.execute("select anzsco4, bbsid, nameen, namecn, ceiling, result, change, ceiling - result as remain from ceilings order by remain")

  CSV.open("#{DATADIR}#{F1819}.csv", "w") do |csv|
    csv << %w(anzsco4 bbsid nameen namecn ceiling result change remain)
    rows.each do |row|
      csv << row
    end
  end

end

def postrawceiling()

    db = SQLite3::Database.open "csol.db"
  
    tablearray = Array.new
    linkarray = Array.new
  
    rows = db.execute("select anzsco4, bbsid, nameen, namecn, ceiling, result, change, ceiling - result as remain from ceilings order by ceiling desc")
  
    puts "飞出国：#{CURRENTFN} 邀请后澳大利亚技术移民 SOL 职业(189+489亲属)配额完成情况飞出国已经整理到网站，下表是飞出国整理的按照邀请人数由多到少的职业列表。"
    puts "\n"
    tablearray.push "代码 | 长表职业类别 - 飞出国 | 18-19配额 "
    tablearray.push "---- | --------------- | -------- "
  
    linkarray.push ""
    anzbbs = YAML.load(File.open("anz4tobbs.yml"))
  
    rows.each do |row|
  
      anz = row[0]
      bbsid = row[1]
      name = "#{row[3]}/#{row[2]}"
      quota = row[4]
      result = row[5]
      change = row[6]
      remain = row[7]
  
      tablearray.push "[#{anz}] | #{name} | #{quota} "
  
      linkarray.push "[#{anz}]: http://bbs.fcgvisa.com/t/flyabroad/#{anzbbs[anz.to_i]}"
  
    end
  
    puts tablearray.join("\n")
    puts FOOT
    puts linkarray.join("\n")
  
  end

def postceiling()

postctx =<<-POST
---
layout: post
title: 2018-2019 年度澳洲 SOL 配额完成情况 - #{CURRENTFN}
date:  #{CURRENTFN} 13:00:00
categories: gsm
---

## #{CURRENTFN} 澳大利亚技术移民 SOL 职业(189+489亲属)配额完成情况

其中的新增邀请意思是这次邀请与上次邀请直接的差额，也就是这次又新邀请的人数（当前邀请数 - 上次更新时的邀请数）。

<table border = "1" cellpadding="1" cellspacing="0">
<tr>
<th>职业代码</th>
<th>职业名称 - 飞出国</th>
<th>配额</th>
<th>邀请</th>
<th>剩余</th>
</tr>
{% for c in site.data.sol.#{CURRENTFN} %}
<tr>
<td> <a href="http://bbs.fcgvisa.com/t/topic/{{ c.bbsid }}" target="_blank">{{ c.anzsco4 }}</a> </td>
<td> {{ c.namecn }}/{{ c.nameen }} </td>
<td> {{ c.ceiling }} </td>
<td> {{ c.result }} </td>
<td> {{ c.remain }} </td>
</tr>
{% endfor %}
</table>

更多说明请参考<a href="http://bbs.fcgvisa.com/t/2018-2019-sol-occupation-ceilings-for-the-2017-18-programme-year/24331" target="blank">飞出国论坛</a> 。

[荷兰库拉索移民](http://www.flyabroad.hk/curacao)适合技术移民无望或技术移民遥遥无期的高知中产阶层人群。一套提供持续较高收益的国际房产（酒店公寓），一个说走就走的国际身份（无移民监），一个中产阶层与欧洲强国护照最接近的移民项目（荷兰护照）。

需要获得相关移民及出国签证申请帮助可以联系飞出国： <a href="http://flyabroad.me/contact" target="_blank">http://flyabroad.me/contact/</a>。

> 以上内容由`飞出国香港`（<a href="http://flyabroad.hk/" target="_blank">flyabroad.hk</a>）整理完成，转载请保留并注明出处。

POST

  File.open("#{POSTDIR}#{CURRENTFN}-SOL-Ceillings.md", 'w') do |file|

    file.write postctx

  end

end

def upateceilling()

  ua = 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0.1) Gecko/20100101 Firefox/9.0.1'
  charset = 'utf-8'

  html = open(TURL, 'User-Agent' => ua)

  doc = Nokogiri::HTML::parse(html, nil, charset)

  table = doc.css("table").last
  trs = table.css("tbody/tr")

  db = SQLite3::Database.open "csol.db"

  CSV.open("#{DATADIR}#{CURRENTFN}.csv", "w") do |csv|
    csv << %w(anzsco4 bbsid nameen namecn ceiling lastresult result change)

    trs.each do |tr|

  next if tr.xpath("td").empty?
  next if tr.xpath("td[1]").empty?

      p td1anzsco4 = tr.xpath("td[1]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip
      td2nameen  = tr.xpath("td[2]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip
      td3ceiling  = tr.xpath("td[3]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip.to_i
      td4result   = tr.xpath("td[4]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip.to_i

      crow = db.execute("select anzsco4, bbsid, nameen, namecn, ceiling, result, updated from ceilings where anzsco4 = ?",td1anzsco4)

      lastresutl = crow[0][5]
      lastupdate = crow[0][6]

      change = td4result - lastresutl

      p "#{td1anzsco4}:#{lastresutl}:#{td4result}:#{change}"

      csv << crow[0].push(td4result).push(change)

      updated = Time.now.strftime("%Y-%m-%d")

      db.execute("update ceilings set result = ? , change = ?, updated = ? where anzsco4 = ?", [td4result, change, updated, td1anzsco4]) if lastupdate != updated

    end
  end

end

def maxeoi

  db = SQLite3::Database.open "csol.db"

  tablearray = Array.new
  linkarray = Array.new

  rows = db.execute("select anzsco4, bbsid, nameen, namecn, ceiling, result, change, ceiling - result as remain from ceilings where change > 0 order by change desc")

  puts "飞出国：#{CURRENTFN} 邀请后澳大利亚技术移民 SOL 职业(189+489亲属)配额完成情况飞出国已经整理到网站，下表是飞出国整理的按照邀请人数由多到少的职业列表。"

  tablearray.push "代码 | 长表职业类别 - 飞出国 | 18-19配额 | 本次邀请 | 剩余配额"
  tablearray.push "---- | --------------- | -------- | -------- | -------"

  linkarray.push ""
  anzbbs = YAML.load(File.open("anz4tobbs.yml"))

  rows.each do |row|

    anz = row[0]
    bbsid = row[1]
    name = "#{row[3]}/#{row[2]}"
    quota = row[4]
    result = row[5]
    change = row[6]
    remain = row[7]

    tablearray.push "[#{anz}] | #{name} | #{quota} | #{change} | #{remain}"

    linkarray.push "[#{anz}]: http://bbs.fcgvisa.com/t/flyabroad/#{anzbbs[anz.to_i]}"

  end

  puts tablearray.join("\n")
  puts FOOT
  puts linkarray.join("\n")

end

# jullog INTERGER DEFAULT NULL,
# auglog INTERGER DEFAULT NULL,
# septlog INTERGER DEFAULT NULL,
# octlog INTERGER DEFAULT NULL,
# novlog INTERGER DEFAULT NULL,
# declog INTERGER DEFAULT NULL,
# janlog INTERGER DEFAULT NULL,
# feblog INTERGER DEFAULT NULL,
# marlog INTERGER DEFAULT NULL,
# aprlog INTERGER DEFAULT NULL,
# maylog INTERGER DEFAULT NULL,
# junlog INTERGER DEFAULT NULL,

# updateceilingslog("auglog-")

# upateceilling()
# postmonthcsv()
# updatecsv()
# postceiling()
postrawceiling

# maxeoi()

#########
def initdb
  ua = 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0.1) Gecko/20100101 Firefox/9.0.1'
  charset = 'utf-8'

  html = open(TURL, 'User-Agent' => ua)

  doc = Nokogiri::HTML::parse(html, nil, charset)

  table = doc.css("table").last
  trs = table.css("tbody/tr")

  anzbbs = YAML.load(File.open("anz4tobbs.yml"))
  anzcn  = YAML.load(File.open("anz4tocn.yml"))

  db = SQLite3::Database.open "csol.db"

    trs.each do |tr|
      next if tr.xpath("td").empty?
      next if tr.xpath("td[1]").empty?

      td1anzsco4 = tr.xpath("td[1]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip
      td2nameen  = tr.xpath("td[2]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip
      td3ceiling  = tr.xpath("td[3]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip.to_i
      # td4result   = tr.xpath("td[4]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip.to_i
      td4result = 0

      db.execute("insert into ceilings (anzsco4, bbsid, nameen, namecn, ceiling) values (?,?,?,?,?)",
        [td1anzsco4,anzbbs[td1anzsco4.to_i] , td2nameen, anzcn[td1anzsco4.to_i], td3ceiling])

      db.execute("insert into ceilingslog (anzsco4) values (#{td1anzsco4})")

    end

end

#########

def recreateceilingtable()

  db = SQLite3::Database.open "csol.db"

    db.execute("Drop table if exists ceilings")
    # anzsco4, bbsid, nameen, namecn, ceiling, result, change
    rows = db.execute <<-SQL
      create table ceilings (
      Id INTEGER PRIMARY KEY AUTOINCREMENT,
      anzsco4 TEXT DEFAULT NULL,
      bbsid INTERGER DEFAULT NULL,
      nameen TEXT DEFAULT NULL,
      namecn TEXT DEFAULT NULL,
      ceiling INTERGER DEFAULT NULL,
      result INTERGER DEFAULT 0,
      change INTERGER DEFAULT 0,
      updated TEXT DEFAULT NULL
      );
    SQL

    db.close

end

def recreateceilinglogtable()

  db = SQLite3::Database.open "csol.db"

    db.execute("Drop table if exists ceilingslog")
    # anzsco4, bbsid, nameen, namecn, ceiling, result, change
    rows = db.execute <<-SQL
      create table ceilingslog (
      Id INTEGER PRIMARY KEY AUTOINCREMENT,
      anzsco4 TEXT DEFAULT NULL,
      jullog INTERGER DEFAULT NULL,
      auglog INTERGER DEFAULT NULL,
      septlog INTERGER DEFAULT NULL,
      octlog INTERGER DEFAULT NULL,
      novlog INTERGER DEFAULT NULL,
      declog INTERGER DEFAULT NULL,
      janlog INTERGER DEFAULT NULL,
      feblog INTERGER DEFAULT NULL,
      marlog INTERGER DEFAULT NULL,
      aprlog INTERGER DEFAULT NULL,
      maylog INTERGER DEFAULT NULL,
      junlog INTERGER DEFAULT NULL,
      updated TEXT DEFAULT NULL
      );
    SQL
    # 一月：January Jan.
    # 二月：February Feb.
    # 三月：March Mar.
    # 四月：April Apr.
    # 五月：May -
    # 六月：June -
    # 七月：July -
    # 八月：August Aug.
    # 九月：September Sept.
    # 十月：October Oct.
    # 十一月：November Nov.
    # 十二月：December Dec.
    db.close

end

# recreateceilingtable()
# recreateceilinglogtable()
# initdb()