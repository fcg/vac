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

TURL = "http://www.border.gov.au/Trav/Work/Skil"

CURRENTFN = "2017-10-18"  # 每次有新更新先修改这里
F1718 = "ceilling-17-18"
DATADIR = "../_data/sol/"
POSTDIR = "../_posts/"

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

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

      p td1anzsco4 = tr.xpath("td[1]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip
      td2nameen  = tr.xpath("td[2]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip
      td3ceiling  = tr.xpath("td[3]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip.to_i
      td4result   = tr.xpath("td[4]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip.to_i

      db.execute("insert into ceilings (anzsco4, bbsid, nameen, namecn, ceiling, result, change) values (?,?,?,?,?,?,?)",
        [td1anzsco4,anzbbs[td1anzsco4.to_i] , td2nameen, anzcn[td1anzsco4.to_i], td3ceiling, td4result, td4result])

    end

end

def updatecsv()

  db = SQLite3::Database.open "csol.db"

  rows = db.execute("select anzsco4, bbsid, nameen, namecn, ceiling, result, change, ceiling - result as remain from ceilings order by remain")

  CSV.open("#{DATADIR}#{F1718}.csv", "w") do |csv|
    csv << %w(anzsco4 bbsid nameen namecn ceiling result change remain)
    rows.each do |row|
      csv << row
    end
  end

end

def postceiling()

postctx =<<-POST
---
layout: post
title: 2017-2018 年度澳洲 SOL 配额完成情况 - #{CURRENTFN}
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
<th>已邀请</th>
<th>新增</th>
</tr>
{% for c in site.data.sol.#{CURRENTFN} %}
<tr>
<td> <a href="http://bbs.fcgvisa.com/t/topic/{{ c.bbsid }}" target="_blank">{{ c.anzsco4 }}</a> </td>
<td> {{ c.namecn }} </td>
<td> {{ c.ceiling }} </td>
<td> {{ c.result }} </td>
<td> {{ c.change }} </td>
</tr>
{% endfor %}
</table>

更多说明请参考<a href="http://bbs.fcgvisa.com/t/2017-2018-sol-occupation-ceilings-for-the-2017-18-programme-year/24331" target="blank">飞出国论坛</a> 。

需要获得相关移民及出国签证申请帮助可以联系飞出国微信（flyabroad）： <a href="http://flyabroad.me/contact" target="_blank">http://flyabroad.me</a>。

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

      td1anzsco4 = tr.xpath("td[1]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip
      td2nameen  = tr.xpath("td[2]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip
      td3ceiling  = tr.xpath("td[3]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip.to_i
      td4result   = tr.xpath("td[4]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip.to_i

      crow = db.execute("select anzsco4, bbsid, nameen, namecn, ceiling, result from ceilings where anzsco4 = ?",td1anzsco4)

      lastresutl = crow[0][5]

      change = td4result - lastresutl

      p "#{td1anzsco4}:#{lastresutl}:#{td4result}:#{change}"

      csv << crow[0].push(td4result).push(change)

      updated = Time.now.strftime("%Y-%m-%d")
      db.execute("update ceilings set result = ? , change = ?, updated = ? where anzsco4 = ?", [td4result, change, updated, td1anzsco4])

    end
  end

end

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
      result INTERGER DEFAULT NULL,
      change INTERGER DEFAULT NULL,
      updated TEXT DEFAULT NULL
      );
    SQL

    db.close

end

# recreateceilingtable()
# initdb()

def maxeoi

  db = SQLite3::Database.open "csol.db"

  tablearray = Array.new
  linkarray = Array.new

  rows = db.execute("select anzsco4, bbsid, nameen, namecn, ceiling, result, change, ceiling - result as remain from ceilings where change > 0 order by change desc")

  puts "飞出国：本次邀请后澳大利亚技术移民 SOL 职业(189+489亲属)配额完成情况飞出国已经整理到网站，下表是飞出国整理的按照邀请人数由多到少的职业列表。"

  tablearray.push "代码 | 职业名称 - 飞出国 | 17-18配额 | 本次邀请 | 剩余配额"
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
  puts linkarray.join("\n")

end

upateceilling()
updatecsv()
postceiling()

maxeoi()