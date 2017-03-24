require 'Nokogiri'
require 'open-uri'
require 'openssl'
require 'sqlite3'
require 'csv'
require 'net/http'
require "yaml"

CEILINGS   = "//*[@id='tab-content-3']/table"
CEILINGTRS = "//*[@id='tab-content-3']/table/tbody/tr"
#TURL = "https://www.border.gov.au/Busi/Empl/skillselect"

TURL = "http://www.border.gov.au/Trav/Work/Skil"

CURRENTFN = "2017-03-15"  # 每次有新更新先修改这里

F1617 = "ceilling-16-17"

DATADIR = "../_data/sol/"

POSTDIR = "../_posts/"

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

def initdb
  ua = 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0.1) Gecko/20100101 Firefox/9.0.1'
  charset = 'utf-8'

  html = open(TURL, 'User-Agent' => ua)

  doc = Nokogiri::HTML::parse(html, nil, charset)

  table = doc.css(".table-100").last

  trs = table.css("tbody>tr")

  anzbbs = YAML.load(File.open("anz4tobbs.yml"))
  anzcn  = YAML.load(File.open("anz4tocn.yml"))

  db = SQLite3::Database.open "csol.db"

    trs.each do |tr|

      td1anzsco4 = tr.xpath("td[1]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip
      td2nameen  = tr.xpath("td[2]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip
      td3ceiling  = tr.xpath("td[3]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip.to_i
      td4result   = tr.xpath("td[4]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip.to_i

      db.execute("insert into ceilings1617 (anzsco4, bbsid, nameen, namecn, ceiling, result, change) values (?,?,?,?,?,?,?)",
        [td1anzsco4,anzbbs[td1anzsco4.to_i] , td2nameen, anzcn[td1anzsco4.to_i], td3ceiling, td4result, td4result])

    end

end

def updatecsv()

  db = SQLite3::Database.open "csol.db"

  rows = db.execute("select anzsco4, bbsid, nameen, namecn, ceiling, result, change, ceiling - result as remain from ceilings1617 order by remain")

  CSV.open("#{DATADIR}#{F1617}.csv", "w") do |csv|
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
title: 澳洲 SOL 配额完成情况 - #{CURRENTFN}
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

更多说明请参考<a href="http://bbs.fcgvisa.com/t/2016-2017-sol-occupation-ceilings-for-each-occupation-on-the-skilled-occupation-list/15923" target="blank">飞出国论坛</a> 。

需要获得相关移民及出国签证申请帮助可以联系飞出国微信（fcgvisabbs）： <a href="http://flyabroad.me/contact" target="_blank">http://flyabroad.me</a>。

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

  # table = doc.css(".table-100").last

  # trs = table.css("tbody>tr")

  table = doc.css("table").last

  trs = table.css("tbody>tr")

  db = SQLite3::Database.open "csol.db"

  CSV.open("#{DATADIR}#{CURRENTFN}.csv", "w") do |csv|
    csv << %w(anzsco4 bbsid nameen namecn ceiling lastresult result change)

    trs.each do |tr|

	next if tr.xpath("td").empty?

      td1anzsco4 = tr.xpath("td[1]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip
      td2nameen  = tr.xpath("td[2]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip
      td3ceiling  = tr.xpath("td[3]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip.to_i
      td4result   = tr.xpath("td[4]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip.to_i

      crow = db.execute("select anzsco4, bbsid, nameen, namecn, ceiling, result from ceilings1617 where anzsco4 = ?",td1anzsco4)

      lastresutl = crow[0][5]

      change = td4result - lastresutl

      p "#{td1anzsco4}:#{lastresutl}:#{td4result}:#{change}"

      csv << crow[0].push(td4result).push(change)

      db.execute("update ceilings1617 set result = ? , change = ? where anzsco4 = ?", [td4result, change, td1anzsco4])

    end
  end

end

# ceiling－16-17 用于 SOL ，按邀请发放的申请人数排序
# 2016-07-06 类用于当前的 post ，不排序，change

# def builddatecsv
#
#   db = SQLite3::Database.open "csol.db"
#
#   CSV.open("#{DATADIR}#{F1617}.csv", "w") do |csv|
#     csv << %w(anzsco4 bbsid nameen namecn ceiling lastresult result change remain)
#
#     crows = db.execute("select anzsco4, bbsid, nameen, namecn, ceiling, 0 AS lastresult, result, result AS change, ceiling - result AS remain from ceilings1617 order by result desc")
#
#     crows.each do |row|
#       csv << row
#     end
#
#   end
#
# end
#
# builddatecsv()

upateceilling()
updatecsv()
postceiling()
