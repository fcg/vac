require 'Nokogiri'
require 'open-uri'
require 'openssl'
require 'sqlite3'
require 'csv'
require 'net/http'
require "yaml"
require 'date'
require 'reverse_markdown'

NOMI16   = ".//*[@id='sub-heading-3']/table[1]/tbody/tr"
NOMI1516 = ".//*[@id='sub-heading-3']/table[2]/tbody/tr"

CUTOFFTABLEROW = ".//*[@id='ctl00_PlaceHolderMain_PublishingPageContent__ControlWrapper_RichHtmlField']/table[4]/tbody/tr"

TURL = "http://www.border.gov.au/Trav/Work/Skil"

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

def download_skillselect()

	open('skillselect.html', 'wb') do |file|
	  puts "download skillselect html"
	  file << open(TURL, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}).read
	end

end

def download_doc(url,name)

	open("2016/#{name}", 'wb') do |file|
	  puts "download #{name}"
	  file << open(url, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}).read
	end

end

ReverseMarkdown.config do |config|
  config.unknown_tags     = :pass_through
  config.github_flavored  = true
  config.tag_border  = ''
end

# 解析最新澳洲 skillselect round 邀请情况并生成对应的 csv 文件和 post 文件
def parse_current(filename)

  csvdir = '../_data/ee/'
  postdir = '../_posts/'

  anzbbs = YAML.load(File.open("anz4tobbs.yml"))
  anzcn  = YAML.load(File.open("anz4tocn.yml"))  

  html = open(filename)
  charset = 'utf-8'

  doc = Nokogiri::HTML::parse(html, nil, charset)

  maindiv = doc.css("#main-content > div").last

  body = ReverseMarkdown.convert maindiv.inner_html

  # p body

  rawcontext = body.gsub("[](/","[](http://www.homeaffairs.gov.au/")
  .gsub("/trav/visa-1/189-","http://js.flyabroad.com.hk/au/189")
  .gsub("/trav/visa-1/489-","http://js.flyabroad.com.hk/au/489")
  .gsub("http://www.homeaffairs.gov.au","")
  .gsub(/\| \n/,"\| ").gsub(/\n \|/," \|").lines.join("> ")

  datestring = maindiv.xpath('//*[@id="page-content"]/div[1]/div/h1').text.gsub(" Invitation Round","").strip

  # datestring = maindiv.css("#ctl00_PlaceHolderMain_PublishingPageContent__ControlWrapper_RichHtmlField > p:nth-child(2) > strong")[0].text.gsub("Invitations issued\u00A0on\u00A0","").gsub("\u00A0"," ").strip
  # datestring = maindiv.css("div")[1].css("strong")[0].text.gsub("Invitations issued\u00A0on\u00A0","").gsub("\u00A0"," ").strip
  updated = DateTime.parse(datestring).strftime("%Y-%m-%d")

  # updated = "2017-02-01"
  # 因为表格模式改变，需要调整新的顺序

  tbs = maindiv.css("table")

#  p n189 = tbs[0].css("td")[1].inner_text.gsub(",","").to_i
#  p n489 = tbs[0].css("td")[3].inner_text.gsub(",","").to_i

#  p t189 = tbs[1].css("tr")[1].css("td").last.text.strip
#  p t489 = tbs[1].css("tr")[2].css("td").last.text.strip
#  p tall = tbs[1].css("tr")[3].css("td").last.text.strip

#   p dtp189 = tbs[2].css("td")[1].text.strip
#   p dtp489 = tbs[2].css("td")[4].text.strip

# p tbs[2].css("td")[2].text.strip 
# p tbs[2].css("td")[5].text.strip

p n189 = tbs[0].css("td")[1].inner_text.gsub(",","").to_i
p n489 = tbs[0].css("td")[3].inner_text.gsub(",","").to_i

p t189 = tbs[1].css("tr")[1].css("td").last.text.strip
p t489 = tbs[1].css("tr")[2].css("td").last.text.strip
p tall = tbs[1].css("tr")[3].css("td").last.text.strip

# 分数
 p dtp189 = tbs[2].css("td")[1].text.strip
 p dtp489 = tbs[2].css("td")[4].text.strip

 # 截止日期
p dt189 = tbs[2].css("td")[2].text.strip 
p dt489 = tbs[2].css("td")[5].text.strip

  dt189 = DateTime.strptime(dt189.gsub("\u00A0"," "), "%d/%m/%Y %l:%M %p").strftime("%Y-%m-%d %H:%M")
  dt489 = DateTime.strptime(dt489.gsub("\u00A0"," "), "%d/%m/%Y %l:%M %p").strftime("%Y-%m-%d %H:%M")

  ## Cut Off Occupations
  trows = doc.xpath(CUTOFFTABLEROW)

  occarray = Array.new
  bbslinkarray = Array.new

  occarray.push "代码 | 邀请数量受限职业 - 飞出国 | 邀请分 | 邀请人数 | 邀请截止时间"
  occarray.push "---- | ----------------------- | ----- | ------- | -----------"

  bbslinkarray.push ""

  db = SQLite3::Database.open "csol.db"

  trows.each do |tr|
      next if tr.xpath("td").empty?
      next if tr.xpath("td[1]").inner_text.include? "Occupation"
      td1anzsco4 = tr.xpath("td[1]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip
      td2nameen  = tr.xpath("td[2]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip
      td3points  = tr.xpath("td[3]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip.to_i
      td4date   = tr.xpath("td[4]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip
      namecn = anzcn[td1anzsco4.to_i]
      bbsid = anzbbs[td1anzsco4.to_i]

      row = db.execute("select change from ceilings where anzsco4 = ?",td1anzsco4)

      change = row[0][0]

      db.execute("insert into cutoff (anzsco4, bbsid, nameen, namecn, points, change, effectdate, updated) values (?,?,?,?,?,?,?,?)",
        [td1anzsco4, bbsid, td2nameen, namecn, td3points, change, td4date, updated])
 
      occarray.push "[#{td1anzsco4}] | #{namecn}/#{td2nameen} | #{td3points} | #{change} | #{td4date}"

      bbslinkarray.push "[#{td1anzsco4}]: http://bbs.fcgvisa.com/t/flyabroad/#{bbsid}"
  end

  frontstr = <<-FRON
---
layout: post
title:  "澳洲技术移民 Skillselect EOI  #{updated} 邀请结果，189 签证邀请 #{n189} 份，489 亲属担保 #{n489} 份"
date:   #{updated} 13:56:00  +0800
categories: gsm
---

FRON

intrstr = <<-INTR
## 澳洲技术移民 Skillselect EOI  #{updated} 邀请结果

飞出国：#{updated} 澳洲技术移民 EOI 发出 189 签证邀请 #{n189} 份，489 亲属担保 #{n489} 份，
截止到 #{updated}，澳洲技术移民 EOI 2016-2017 年度共发出 189 邀请 #{t189} 份，489 邀请 #{t489} 份，总计 #{tall} 份。

本次邀请中，189 邀请分数 #{dtp189} 分（截止到 #{dt189}），489 邀请分数 #{dtp489}（截止到 #{dt489}）。

由于申请人数多邀请人数受限的职业邀请分数及邀请到的截止日期-飞出国：

#{occarray.join("\n")}

INTR

linkstr = <<-ENDS

更多请参考飞出国论坛： [澳洲技术移民 Skillselect EOI 2017-2018 年度邀请记录 - fcgvisa](http://bbs.fcgvisa.com/t/skillselect-eoi-2017-2018/24327)。

需要获得相关移民及出国签证申请帮助可以联系飞出国微信（flyabroad）： <a href="http://flyabroad.me/contact" target="_blank">http://flyabroad.me</a>。

> 以上内容由`飞出国香港`（<a href="http://flyabroad.hk/" target="_blank">flyabroad.hk</a>）整理完成，转载请保留并注明出处。

#{bbslinkarray.join("\n")}

ENDS

File.open("#{postdir}#{updated}-Skillselect-Round-Results.md", 'w') do |file|

  content = frontstr + intrstr + rawcontext + linkstr

  file.write content

end

end

# parse_current("https://www.border.gov.au/WorkinginAustralia/Pages/12-july-2017-round-results.aspx")
# parse_current("http://www.border.gov.au/WorkinginAustralia/Pages/26-july-2017-round-results.aspx")
# parse_current("http://www.border.gov.au/WorkinginAustralia/Pages/9-August-2017-round-results.aspx")
# parse_current("http://www.border.gov.au/WorkinginAustralia/Pages/23-august-2017-round-results.aspx")
# parse_current("https://www.border.gov.au/WorkinginAustralia/Pages/06-september-2017-round-results.aspx")
# parse_current("http://www.border.gov.au/WorkinginAustralia/Pages/20-september-2017-round-results.aspx")
# parse_current("https://www.border.gov.au/WorkinginAustralia/Pages/04-October-2017-Round-Results.aspx")
# parse_current("http://www.border.gov.au/WorkinginAustralia/Pages/18-october-invitation-rounds.aspx")
# parse_current("https://www.border.gov.au/WorkinginAustralia/Pages/9-november-invitation-rounds.aspx")
# parse_current("https://www.homeaffairs.gov.au/WorkinginAustralia/Pages/6-december-invitation-round-2017.aspx")
# parse_current("https://www.homeaffairs.gov.au/WorkinginAustralia/Pages/20-december-invitation-round-2017.aspx")
# parse_current("https://www.homeaffairs.gov.au/trav/work/skil/invitation-round-3-january-2018")
# parse_current("http://www.homeaffairs.gov.au/trav/work/skil/invitation-round-18-january-2018")
# parse_current("https://www.homeaffairs.gov.au/trav/work/skil/invitation-round-7-february-2018")
# parse_current("https://www.homeaffairs.gov.au/WorkinginAustralia/Pages/21-february-2018-invitation-round.aspx")
# parse_current("https://www.homeaffairs.gov.au/WorkinginAustralia/Pages/7-march-2018-invitation-round.aspx")
# parse_current("https://www.homeaffairs.gov.au/WorkinginAustralia/Pages/21-march-2018-invitation-round.aspx")
# parse_current("https://www.homeaffairs.gov.au/WorkinginAustralia/Pages/4-april-2018-invitation-round.aspx")
# parse_current("https://www.homeaffairs.gov.au/WorkinginAustralia/Pages/18-april-2018-invitation-round.aspx")
# parse_current("https://www.homeaffairs.gov.au/WorkinginAustralia/Pages/9-may-2018-invitation-round.aspx")
# parse_current("https://www.homeaffairs.gov.au/WorkinginAustralia/Pages/23-may-2018-invitation-round.aspx")
parse_current("https://www.homeaffairs.gov.au/WorkinginAustralia/Pages/6-june-2018-invitation-round.aspx")

def recreatecutofftable()

  db = SQLite3::Database.open "csol.db"

    db.execute("Drop table if exists cutoff")
    # anzsco4, bbsid, nameen, namecn, ceiling, result, change
    rows = db.execute <<-SQL
      create table cutoff (
      Id INTEGER PRIMARY KEY AUTOINCREMENT,
      anzsco4 TEXT DEFAULT NULL,
      bbsid INTERGER DEFAULT NULL,
      nameen TEXT DEFAULT NULL,
      namecn TEXT DEFAULT NULL,
      points INTERGER DEFAULT NULL,
      change INTERGER DEFAULT NULL,
      effectdate TEXT DEFAULT NULL,
      updated TEXT DEFAULT NULL
      );
    SQL

    db.close

end

def loadoldcutoff()
  db1 = SQLite3::Database.open "2016/csol-83.db"
  db2 = SQLite3::Database.open "csol.db"

  rows = db1.execute "select anzsco4,bbsid,nameen,namecn,points,change,effectdate,updated from cutoff"

  rows.each do |row|
    db2.execute("insert into cutoff (anzsco4,bbsid,nameen,namecn,points,change,effectdate,updated) values(?,?,?,?,?,?,?,?)",row)
  end

end

def build_cutoff(filename)

  anzbbs = YAML.load(File.open("anz4tobbs.yml"))
  anzcn  = YAML.load(File.open("anz4tocn.yml"))  

  html = open(filename)
  charset = 'utf-8'

  doc = Nokogiri::HTML::parse(html, nil, charset)

  maindiv = doc.css(".ym-gbox-left").last

  body = ReverseMarkdown.convert maindiv.inner_html

  rawcontext = body.gsub("[](/","[](https://www.border.gov.au/").gsub(/\| \n/,"\| ").gsub(/\n \|/," \|").lines.join("> ")

  datestring = maindiv.css("div")[1].css("strong")[0].text.gsub("Invitations issued\u00A0on\u00A0","").gsub("\u00A0"," ").strip
  updated = DateTime.parse(datestring).strftime("%Y-%m-%d")

  ## Cut Off Occupations
  trows = doc.xpath(CUTOFFTABLEROW)

  occarray = Array.new
  bbslinkarray = Array.new

  occarray.push "代码 | 邀请数量受限职业 - 飞出国 | 邀请分 | 邀请人数 | 邀请截止时间"
  occarray.push "---- | ----------------------- | ----- | ------- | -----------"

  bbslinkarray.push ""

  db = SQLite3::Database.open "csol.db"

  trows.each do |tr|
      next if tr.xpath("td").empty?
      next if tr.xpath("td[1]").inner_text.include? "Occupation"
      td1anzsco4 = tr.xpath("td[1]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip
      td2nameen  = tr.xpath("td[2]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip
      td3points  = tr.xpath("td[3]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip.to_i
      td4date   = tr.xpath("td[4]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip
      namecn = anzcn[td1anzsco4.to_i]
      bbsid = anzbbs[td1anzsco4.to_i]

      row = db.execute("select change from ceilings where anzsco4 = ?",td1anzsco4)

      change = row[0][0]
 
      occarray.push "[#{td1anzsco4}] | #{namecn}/#{td2nameen} | #{td3points} | #{change} | #{td4date}"

      bbslinkarray.push "[#{td1anzsco4}]: http://bbs.fcgvisa.com/t/flyabroad/#{bbsid}"

      db.execute("insert into cutoff (anzsco4, bbsid, nameen, namecn, points, change, effectdate, updated) values (?,?,?,?,?,?,?,?)",
        [td1anzsco4, bbsid, td2nameen, namecn, td3points, change, td4date, updated])
  end

  puts occarray.join("\n")

end

# recreatecutofftable()
# loadoldcutoff()
# build_cutoff("https://www.border.gov.au/WorkinginAustralia/Pages/26-july-2017-round-results.aspx")