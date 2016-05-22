require 'Nokogiri'
require 'open-uri'
require 'haml'
require 'reverse_markdown'
require "sqlite3"
require 'csv'

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

def posttovac()

  bbslink = 'http://bbs.fcgvisa.com/t/2016-express-entry-ita-ee/9588'
  csvdir = '../_data/ee/'
  postdir = '../_posts/'

  db = SQLite3::Database.open "eedraws.db"

  unposted = "select TotalNum,date(EEDate), EEinvitations,EErank,NumInYear,MIBody from eedraws where posted is null"
  updateposted = "update eedraws set posted = 1 where TotalNum = ?"
  selectposted = "select TotalNum,date(EEDate), EEinvitations,EErank,NumInYear from eedraws where TotalNum <= ?"

  arr = Array.new

  db.execute( unposted ) do |row|

     totalnum  = row[0],
     eedate = row[1],
     eeinvitations = row[2],
     eerank = row[3],
     numinyear = row[4],
     mibody = row[5]

     currentNum = totalnum[0]

     maxrank = db.execute("select MAX(EErank) from eedraws where TotalNum <= ?", [currentNum]).first[0]
     minrank = db.execute("select MIN(EErank) from eedraws where TotalNum <= ?", [currentNum]).first[0]
     sumnum  = db.execute("select SUM(EEinvitations) from eedraws where TotalNum <= ?",[currentNum]).first[0]

    #  p currentNum
    #  p currentNum[0]

     eecsvfile = "EE#{eedate}"
     eepostfile = "#{eedate}-Express-Entry-Draw-#{currentNum}-#{eerank}-points-#{eeinvitations}"

     CSV.open("#{csvdir}EE#{eedate}.csv", "w") do |csv|
       csv << ["no","date","people","points","numinyear"]
       db.execute( selectposted, currentNum ) do |draw|
         csv << draw
       end
       csv << ["飞出国","<b>累计人数：</b>",sumnum,minrank,"<b>最低分数：</b>"]
     end

  frontstr = <<-YAML
---
layout: post
title:  "Express Entry #{eedate} 2016 年第 #{numinyear} 捞：#{eeinvitations}人，#{eerank}分"
date:   #{eedate} 23:56:00  +0800
categories: EE
---
YAML

  intrstr = <<-INTR

飞出国：加拿大时间 #{eedate}，CIC 发布 Express Entry 2016 年第 #{numinyear} 捞（总第 #{currentNum} 捞），#{eeinvitations}人，#{eerank}分。

截止到现在加拿大 EE 累计捞取 #{sumnum} 人，历次最低分 #{minrank} 分，历次最高分 #{maxrank}分。飞出国加拿大 EE 历次邀请情况记录：

<table border = "1" cellpadding="1" cellspacing="0">
  <tr>
    <th>EE 总邀请次数</th>
    <th>EE 邀请日期</th>
    <th>EE 邀请人数</th>
    <th>年度邀请次数</th>
    <th>EE 邀请分数</th>
  </tr>
{% for ee in site.data.ee.#{eecsvfile} %}
<tr>
<td> {{ ee.no }} </td>
<td> {{ ee.date }} </td>
<td> {{ ee.people }} </td>
<td> {{ ee.numinyear }} </td>
<td> {{ ee.points }} </td>
</tr>
{% endfor %}
</table>

------

INTR

  bbsstr = "2016年EE邀请情况请参考<a href=\"#{bbslink}\" target=\"_blank\">飞出国论坛 Express Entry 邀请情况记录</a>。"

    File.open("#{postdir}#{eepostfile}.md", 'w') do |file|

      content = frontstr + intrstr + bbsstr

      file.write content

    end

     db.execute( updateposted, currentNum )

  end

  db.close

end

parsenewee()
posttovac()
